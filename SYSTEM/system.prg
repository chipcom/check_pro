#include 'set.ch'
#include 'common.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'

// c4sys_date := dtoc4(sys_date)

//
FUNCTION ne_real()

  n_message({'Приносим извинения.',;
             'В данный момент функция не реализована.'}, , cColorStMsg, cColorStMsg, , , cColorSt2Msg)
  return NIL
  
  
function cur_year()
  static _cur_year
  if isnil(_cur_year)
    _cur_year := STR(YEAR(sys_date), 4)
  endif
  return _cur_year

function __full_name()
  
  return 'ЧИП + служебные утилиты'

function cur_dir()
  static _cur_dir
  local cPrefix

  if isnil(_cur_dir)
#ifdef __PLATFORM__UNIX
      cPrefix := '/'
#else
      cPrefix := hb_curDrive() + ':\'
#endif
  _cur_dir := cPrefix + CurDir() + hb_ps()
  endif
  return _cur_dir

function dir_server()
   static _dir_server
   local mem_file := cur_dir() + 'server.mem'
  
   if isnil(_dir_server)
    if hb_FileExists(mem_file)
      ft_use(mem_file)
      _dir_server := alltrim(ft_readln())
      ft_use()
      if right(_dir_server, 1) != hb_ps()    // '\'
        _dir_server += hb_ps()    // '\'
      endif
    else // иначе = текущий каталог
      hb_Alert('Отсутствует файл ' + mem_file)
      _dir_server := ''
    endif
   endif
   return _dir_server

function dir_exe()
  static _dir_exe
  
  if isnil(_dir_exe)
    _dir_exe := upper(beforatnum(hb_ps(), exename())) + hb_ps()
  endif
  return _dir_exe
  
function exe_dir()
  return dir_exe()

function cur_drv()
  return DISKNAME()

// попадает ли date1 (диапазон date1-date2) в диапазон _begin_date-_end_date
Function between_date(_begin_date, _end_date, date1, date2, impossiblyEmptyRange)
  // _begin_date - начало действия
  // _end_date   - окончание действия
  // date1 - проверяемая дата
  // date2 - вторая дата диапазона (если = NIL, то проверяем только по date1)
  // impossiblyEmptyRange - если .t. пустой диапазон дат не допустим
  Local fl := .f., fl2

  // проверим на недопустимость пустого диапазона дат
  if ! hb_isnil( impossiblyEmptyRange ) .and. impossiblyEmptyRange
    if empty(_begin_date) .and. empty(_end_date)
      return fl
    endif
  endif

  DEFAULT date1 TO sys_date  // по умолчанию проверяем на сегодняшний момент
  if empty(_begin_date)
    _begin_date := stod('19930101')  // если начало действия = пусто, то 01.01.1993
  endif
  // проверка даты date1 на попадание в диапазон
  if (fl := (date1 >= _begin_date)) .and. !empty(_end_date)
    fl := (date1 <= _end_date)
  endif
  // проверка диапазона date1-date2 на пересечение с диапазоном
  if valtype(date2) == 'D'
    if (fl2 := (date2 >= _begin_date)) .and. !empty(_end_date)
      fl2 := (date2 <= _end_date)
    endif
    fl := (fl .or. fl2)
  endif
  return fl

// для 1-3ур. вернуть уровень для услуг 'койко-день' или 1-й для остальных
Function get2uroven(sShifr, nU)

  DEFAULT nU TO get_uroven()
  if nU < 4 .and. !(left(sShifr, 2) == '1.')
    nU := 1
  endif
  return nU

// 11.01.13 вернуть уровень МО в зависимости от даты
Function get_uroven(dDate)
  Local i, ret := 4 // с 2013 года у всех индивидуальные тарифы

  DEFAULT dDate TO sys_date
  if year(dDate) < 2013
    for i := 1 to len(glob_mo[_MO_UROVEN])
      if dDate >= glob_mo[_MO_UROVEN, i, 1]
        ret := glob_mo[_MO_UROVEN,i, 2]
      endif
    next
  endif
  return ret

// 15.01.14 функция сортировки шифров услуг по возрастанию (для команды INDEX)
Function fsort_usl(sh_u)
  Static _sg := 5
  Local i, s := '', flag_z := .f., flag_0 := .f., arr

  if left(sh_u, 1) == '*'
    flag_z := .t.
  elseif left(sh_u, 1) == '0'
    flag_0 := .t.
  endif
  arr := usl2arr(sh_u)
  for i := 1 to len(arr)
    if i == 2 .and. flag_z
      s += '9' + strzero(arr[i], _sg)  // для удаленной услуги
    elseif i == 1 .and. flag_0
      s += ' ' + strzero(arr[i], _sg)  // если впереди стоит 0
    else
      s += strzero(arr[i], 1 + _sg)
    endif
  next
  return s

// 16.06.23 проверка отключения подразделений
function disable_podrazdelenie_TFOMS(lkdate)
  local ret := .f.
  local aCodem := { ;
    '101001', ;
    '103001', ;
    '121125', ;
    '141023', ;
    '161007', ;
    '171004', ;
    '151005', ;
    '101201', ;
    '131001' ;
  }

  // В соответствии с решением Комиссии от 13.06.2023 с 01.06.2023 изменены уровни оплаты для ряда МО.
  if ascan(aCodem, glob_mo[_MO_KOD_TFOMS]) != 0 .and. lkdate >= 0d20230601
    ret := .t.
  endif

  return ret

// 15.01.18
Function ret_otd_dep()
  Local ret_arr

  if !(valtype(glob_otd_dep) == 'N')
    glob_otd_dep := 0
  endif
  popup_2array(mm_otd_dep, T_ROW, T_COL - 5, glob_otd_dep, 1, @ret_arr, 'Выбор отделения стационара', 'B/BG')
  if valtype(ret_arr) == 'A'
    glob_otd_dep := ret_arr[2]
  endif
  return ret_arr

//
Function a2default(arr, name, sDefault)
  // arr - двумерный массив
  // name - поиск по имени первого элемента
  // sDefault - значение по умолчанию для второго элемента
  Local s := '', i

  if valtype(sDefault) == 'C'
    s := sDefault
  endif
  if (i := ascan(arr, {|x| upper(x[1]) == upper(name)})) > 0
    s := arr[i, 2]
  endif
  return s

//
function get_app_ini()
  return cur_dir() + 'check_pro.ini'

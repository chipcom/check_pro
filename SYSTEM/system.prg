#include 'set.ch'
#include 'common.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'

// c4sys_date := dtoc4(sys_date)

//
FUNCTION ne_real()

  n_message({'�ਭ�ᨬ ���������.',;
             '� ����� ������ �㭪�� �� ॠ��������.'}, , cColorStMsg, cColorStMsg, , , cColorSt2Msg)
  return NIL
  
  
function cur_year()
  static _cur_year
  if isnil(_cur_year)
    _cur_year := STR(YEAR(sys_date), 4)
  endif
  return _cur_year

function __full_name()
  
  return '��� + �㦥��� �⨫���'

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
    else // ���� = ⥪�騩 ��⠫��
      hb_Alert('��������� 䠩� ' + mem_file)
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

// �������� �� date1 (�������� date1-date2) � �������� _begin_date-_end_date
Function between_date(_begin_date, _end_date, date1, date2, impossiblyEmptyRange)
  // _begin_date - ��砫� ����⢨�
  // _end_date   - ����砭�� ����⢨�
  // date1 - �஢��塞�� ���
  // date2 - ���� ��� ��������� (�᫨ = NIL, � �஢��塞 ⮫쪮 �� date1)
  // impossiblyEmptyRange - �᫨ .t. ���⮩ �������� ��� �� �����⨬
  Local fl := .f., fl2

  // �஢�ਬ �� �������⨬���� ���⮣� ��������� ���
  if ! hb_isnil( impossiblyEmptyRange ) .and. impossiblyEmptyRange
    if empty(_begin_date) .and. empty(_end_date)
      return fl
    endif
  endif

  DEFAULT date1 TO sys_date  // �� 㬮�砭�� �஢��塞 �� ᥣ����譨� ������
  if empty(_begin_date)
    _begin_date := stod('19930101')  // �᫨ ��砫� ����⢨� = ����, � 01.01.1993
  endif
  // �஢�ઠ ���� date1 �� ��������� � ��������
  if (fl := (date1 >= _begin_date)) .and. !empty(_end_date)
    fl := (date1 <= _end_date)
  endif
  // �஢�ઠ ��������� date1-date2 �� ����祭�� � ����������
  if valtype(date2) == 'D'
    if (fl2 := (date2 >= _begin_date)) .and. !empty(_end_date)
      fl2 := (date2 <= _end_date)
    endif
    fl := (fl .or. fl2)
  endif
  return fl

// ��� 1-3��. ������ �஢��� ��� ��� '�����-����' ��� 1-� ��� ��⠫���
Function get2uroven(sShifr, nU)

  DEFAULT nU TO get_uroven()
  if nU < 4 .and. !(left(sShifr, 2) == '1.')
    nU := 1
  endif
  return nU

// 11.01.13 ������ �஢��� �� � ����ᨬ��� �� ����
Function get_uroven(dDate)
  Local i, ret := 4 // � 2013 ���� � ��� �������㠫�� ����

  DEFAULT dDate TO sys_date
  if year(dDate) < 2013
    for i := 1 to len(glob_mo[_MO_UROVEN])
      if dDate >= glob_mo[_MO_UROVEN, i, 1]
        ret := glob_mo[_MO_UROVEN,i, 2]
      endif
    next
  endif
  return ret

// 15.01.14 �㭪�� ���஢�� ��஢ ��� �� �����⠭�� (��� ������� INDEX)
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
      s += '9' + strzero(arr[i], _sg)  // ��� 㤠������ ��㣨
    elseif i == 1 .and. flag_0
      s += ' ' + strzero(arr[i], _sg)  // �᫨ ���।� �⮨� 0
    else
      s += strzero(arr[i], 1 + _sg)
    endif
  next
  return s

// 16.06.23 �஢�ઠ �⪫�祭�� ���ࠧ�������
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

  // � ᮮ⢥��⢨� � �襭��� �����ᨨ �� 13.06.2023 � 01.06.2023 �������� �஢�� ������ ��� �鸞 ��.
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
  popup_2array(mm_otd_dep, T_ROW, T_COL - 5, glob_otd_dep, 1, @ret_arr, '�롮� �⤥����� ��樮���', 'B/BG')
  if valtype(ret_arr) == 'A'
    glob_otd_dep := ret_arr[2]
  endif
  return ret_arr

//
Function a2default(arr, name, sDefault)
  // arr - ��㬥�� ���ᨢ
  // name - ���� �� ����� ��ࢮ�� �����
  // sDefault - ���祭�� �� 㬮�砭�� ��� ��ண� �����
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

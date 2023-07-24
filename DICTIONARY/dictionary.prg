#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'

// 16.06.23
Function print_uslugi()
  Static sdate
  Local k, buf := save_maxrow(), name_file := cur_dir + 'uslugi' + stxt, nu, ret_arr, ;
      sh := 80, HH := 60, t_arr, i, s, fl, v1, v2, mdate, fl1uslc, fl2uslc, ;
      ta[2], lyear, fl1del, fl2del, len_ksg := 10
  local arrKSLP, rowKSLP, tmpKSLP, arrKIRO, rowKIRO, tmpKIRO
  local sbase

  DEFAULT sdate TO sys1_date
  mdate := input_value(20, 5, 22, 73,color1, ;
                     'Дата, по состоянию на которую выводятся цены на услуги', ;
                     sdate)
  if mdate == NIL
    return NIL
  endif
  if (lyear := year(mdate)) < 2018
    return func_error(4, 'Вы запрашиваете слишком старую информацию')
  endif
  if lyear > WORK_YEAR
    return func_error(4, 'Информация на будуюшую дату отсутствует')
  endif
  sdate := mdate
  if (k := popup_2array(usl9TFOMS(mdate), T_ROW, T_COL - 5, su, 1, @t_arr, 'Выберите группу услуг', 'B/BG', color0)) > 0
    glob_podr := ''
    if is_otd_dep .and. t_arr[2] == 501 .and. ! disable_podrazdelenie_TFOMS(mdate)
      if (ret_arr := ret_otd_dep()) == NIL
        return NIL
      endif
    else
      glob_otd_dep := 0
    endif
    mywait()
    su := k
    fp := fcreate(name_file)
    n_list := 1
    tek_stroke := 0
    nu := get_uroven(mdate)
    /*if between(nu, 1, 3)
      s := 'Уровень цен на мед.услуги: '+lstr(nu)
    else
      s := 'Индивидуальные тарифы на мед.услуги'
    endif*/
    add_string(glob_mo[_MO_SHORT_NAME] + iif(valtype(ret_arr) == 'A', ' (' + ret_arr[1] + ')', ''))
    add_string('')
    add_string(center('Список услуг по группе', sh))
    add_string(center('"' + alltrim(t_arr[1]) + '"', sh))
    add_string(center('[ цены по состоянию на ' + date_8(mdate) + 'г. ]', sh))
    add_string('')
    if t_arr[2] > 500
      arrKSLP := getKSLPtable( mdate )
      add_string('КСЛП:')
      for each rowKSLP in arrKSLP
        k := perenos(ta, alltrim(rowKSLP[3]), 58)
        for i := 1 to k
          if i == 1
            tmpKSLP := str(rowKSLP[1], 7) + ' - ' + ta[i] + ' (коеф=' + str(rowKSLP[4], 4, 2) + ')'
          else
            tmpKSLP := space(10) + ta[i]
          endif
          add_string(tmpKSLP)
        next
      next
      arrKIRO := getKIROtable( mdate )
      add_string('КИРО:')
      for each rowKIRO in arrKIRO
        if between_date(rowKIRO[5], rowKIRO[6], mdate)
          k := perenos(ta, alltrim(rowKIRO[3]), 58)
          for i := 1 to k
            if i == 1
              tmpKIRO := str(rowKIRO[1], 7) + ' - ' + ta[i] + ' (коеф=' + str(rowKIRO[4], 4, 2) + ')'
            else
              tmpKIRO := space(10) + ta[i]
            endif
            add_string(tmpKIRO)
          next
        endif
      next

      sbase := prefixFileRefName(lyear) + 'k006'
      R_Use(exe_dir + sbase, , 'K006')
    
      index on SHIFR + str(ns, 6) to (cur_dir + 'tmp_k006') unique
      index on SHIFR + str(ns, 6)+ds+sy to (cur_dir + 'tmp_k006_')
      set index to (cur_dir + 'tmp_k006'), (cur_dir + 'tmp_k006_')
    endif
    use_base('luslc')
    use_base('lusl')
    lal := 'lusl'
    lal := create_name_alias(lal, lyear)

    dbSelectArea(lal)
    if t_arr[2] > 500
      index on fsort_usl(shifr) to (cur_dir + 'tmplu') for is_ksg(shifr, t_arr[2] - 500) .and. datebeg >= boy(mdate)
    else
      index on fsort_usl(shifr) to (cur_dir + 'tmp') for usl2arr(shifr)[1]==k .and. !is_ksg(shifr)
    endif
    go top
    do while !eof()
      v1 := fcena_oms(&lal.->shifr, .t., mdate, @fl1del, @fl1uslc)
      v2 := fcena_oms(&lal.->shifr, .f., mdate, @fl2del, @fl2uslc)
      if !(fl1del .and. fl2del)
        s := alltrim(&lal.->name)
        if len(alltrim(&lal.->shifr)) == 10
          s := ' ' + s
        endif
        k := perenos(ta, s, 50)
        verify_FF(HH - k - 1, .t., sh)
        if t_arr[2] > 100
          add_string(replicate('─', sh))
        endif
        add_string(&lal.->shifr + ta[1] + ;
                 iif(fl1del,'      -   ', put_kop(v1, 10)) + ;
                 iif(fl2del,'      -   ', put_kop(v2, 10)))
        s := space(10) + padr(ta[2], 50)
        if !empty(s)
          add_string(s)
        endif
        for i := 3 to k
          add_string(space(10) + ta[i])
        next
        if t_arr[2] > 500
          select K006
          set order to 1
          find (padr(&lal.->shifr, len_ksg))
          s1 := f_ret_kz_ksg(k006->kz, &lal.->kslps, &lal.->kiros)
          add_string(space(10) + s1)
          do while padr(&lal.->shifr, len_ksg) == k006->shifr .and. !eof()
            if between_date(k006->DATEBEG, k006->DATEEND, mdate)
              lrec := k006->(recno())
              lns := k006->ns
              i := 0
              s := s1 := ''
              set order to 2
              find (padr(&lal.->shifr, len_ksg) + str(lns, 6))
              do while padr(&lal.->shifr, len_ksg) == k006->shifr .and. lns == k006->ns .and. !eof()
                if !empty(k006->DS)
                  s1 += alltrim(k006->DS) + ' '
                endif
                if ++i == 1
                  if !empty(k006->DS1)
                    s += 'СОПУТ.Диагноз ' + alltrim(k006->DS1) + '; '
                  endif
                  if !empty(k006->DS2)
                    s += 'Диагноз ОСЛОЖНЕНИЯ ' + alltrim(k006->DS2) + '; '
                  endif
                  if !empty(k006->SY)
                    s += 'УСЛУГА ' + alltrim(k006->sy) + '; '
                  endif
                  if !empty(k006->AGE)
                    s += 'ВОЗРАСТ ' + ret_vozrast_k006(k006->AGE) + '; '
                  endif
                  if !empty(k006->SEX)
                    s += 'ПОЛ ' + iif(k006->SEX == '1', 'мужской', 'женский') + '; '
                  endif
                  if !empty(k006->LOS)
                    s += ret_duration_k006(k006->LOS, iif(left(&lal.->shifr, 1) == '1', 'койко', 'пациенто') + '-') + '; '
                  endif
                  if k006->(fieldpos('RSLT')) > 0 .and. !empty(k006->RSLT)
                    s += 'РЕЗУЛЬТАТ ' + alltrim(k006->RSLT) + '; '
                  endif
                  if k006->(fieldpos('AD_CR')) > 0 .and. !empty(k006->AD_CR)
                    s += 'ДОП.КРИТЕРИЙ ' + alltrim(k006->AD_CR) + '; '
                  endif
                  if k006->(fieldpos('AD_CR1')) > 0 .and. !empty(k006->AD_CR1)
                    s += 'ИНОЙ КРИТЕРИЙ ' + alltrim(k006->AD_CR1) + '; '
                  endif
                endif
                skip
              enddo
              if !empty(s1)
                s1 := 'ОСН.Диагноз ' + left(s1, len(s1) - 1) + '; '
              endif
              s := s1 + s
              s := left(s, len(s) - 2)
              k := perenos(ta, s, 70)
              for i := 1 to k
                verify_FF(HH, .t., sh)
                add_string(iif(i == 1, space(8) + '- ', space(10)) + ta[i])
              next
              select K006
              goto (lrec)
              set order to 1
            endif
            skip
          enddo
        endif
      endif
      dbSelectArea(lal)
      skip
    enddo
    close databases
    rest_box(buf)
    fclose(fp)
    viewtext(name_file, , , , .t., , , 2)
  endif
  return NIL

// 08.12.21
Function ret_vozrast_k006(s)
  Local ret := ''

  do case
    case s == '1'
      ret := '0-28 дней'
    case s == '2'
      ret := '29-90 дней'
    case s == '3'
      ret := 'от 91 дня до 1 года'
    case s == '4'
      ret := 'до 2 лет включительно'
    case s == '5'
      ret := 'ребёнок'
    case s == '6'
      ret := 'взрослый'
  endcase
  return ret

// 08.12.21
Function ret_duration_k006(s,s1)
  Static sd := 'день', sdr := 'дня', sdm := 'дней'
  Local arr := {'1-3 ' + s1 + sdr, ;                   //  1
              '4 ' + s1 + sdr + ' и более', ;          //  2
              '1-6 ' + s1 + sdm, ;                     //  3
              '7 ' + s1 + sdm + ' и более', ;          //  4
              '21 ' + s1 + sd + ' и более', ;          //  5
              '1-20 ' + s1 + sdm, ;                    //  6
              '1 ' + s1 + sd, ;                        //  7
              '4-7 ' + s1 + sdm, ;                     //  8
              '8-10 ' + s1 + sdm, ;                    //  9
              '11 ' + s1 + sdm + ' и более'}          // 10
  Local i := int(val(s))

  return 'дл-ть ' + iif(between(i, 1, 10), arr[i], '')

// 08.02.23
Function f_ret_kz_ksg(lkz, lkslp, lkiro)
  Local s := 'коэф-т затратоёмкости ' + lstr(lkz, 5, 2)

  if !empty(lkslp)
    s += '; КСЛП: ' + alltrim(lkslp)
  endif
  if !empty(lkiro)
    s += '; КИРО: ' + alltrim(lkiro)
  endif
  return s

// 15.01.19 превратить шифр услуги в 5-мерный числовой массив
Function usl2arr(sh_u, /*@*/j)
  Local i, k, c, ascc, arr := {}, cDelimiter := '.', s := alltrim(sh_u), ;
      s1 := '', is_all_digit := .t.

  if left(s, 1) == '*'
    s := substr(s, 2)
  endif
  for i := 1 to len(s)
    c := substr(s, i, 1)
    ascc := asc(c)
    if between(ascc, 48, 57) // цифры
      s1 += c
    elseif ISLETTER(c) // буквы
      is_all_digit := .f.
      if len(s1) > 0 .and. right(s1, 1) != cDelimiter
        s1 += cDelimiter // искусственно вставим разделитель
      endif
      s1 += lstr(ascc)
    else // любой разделитель
      is_all_digit := .f.
      s1 += cDelimiter
    endif
  next
  if is_all_digit .and. eq_any((k := len(s1)), 8, 7)  // КСГ
    if k == 8
      aadd(arr, int(val(substr(s1, 1, 1))))
      aadd(arr, int(val(substr(s1, 2, 1))))
      aadd(arr, int(val(substr(s1, 3, 1))))
      aadd(arr, int(val(substr(s1, 6, 3))))
      aadd(arr, int(val(substr(s1, 4, 1))))
    else
      aadd(arr, int(val(substr(s1, 1, 1))))
      aadd(arr, int(val(substr(s1, 2, 1))))
      aadd(arr, int(val(substr(s1, 3, 1))))
      aadd(arr, int(val(substr(s1, 5, 3))))
      aadd(arr, int(val(substr(s1, 4, 1))))
    endif
  else // остальные услуги
    k := numtoken(alltrim(s1), cDelimiter)
    for i := 1 to k
      j := int(val(token(s1, cDelimiter, i)))
      aadd(arr, j)
    next
    if (j := len(arr)) < 5
      for i := j + 1 to 5
        aadd(arr, 0)
      next
    endif
  endif
  return arr

// 03.01.19 является ли шифр услуги кодом КСГ
Function is_ksg(lshifr, k)
  // k = nil - любая КСГ
  // k = 1 - стационар
  // k = 2 - дневной стационар
  Static ss := '0123456789'
  Local i, fl := .f.

  lshifr := alltrim(lshifr)
  if left(lshifr, 2) == 'st'
    if valtype(k) == 'N'
      fl := (int(k) == 1)
    else
      fl := .t.
    endif
  elseif left(lshifr, 2) == 'ds'
    if valtype(k) == 'N'
      fl := (int(k) == 2)
    else
      fl := .t.
    endif
  endif
  if fl
    return fl // для 2019 года
  endif
  if left(lshifr, 1) $ '12' .and. substr(lshifr, 5, 1) == '.' .and. len(lshifr) == 6 // 18 год
    fl := .t.
    for i := 2 to 6
      if i == 5
        loop
      elseif !(substr(lshifr, i, 1) $ ss)
        fl := .f.
        exit
      endif
    next
  elseif !('.' $ lshifr) .and. eq_any(len(lshifr), 8, 7) // КСГ за прошлые годы
    fl := empty(CHARREPL(ss, lshifr, SPACE(10)))
  endif
  if fl .and. valtype(k) == 'N'
    fl := (left(lshifr, 1) == lstr(k))
  endif
  return fl

// 08.11.21
Function usl9TFOMS(mdate)
  Static sdate, sarr1
  Local arr := {{' 1. Койко-дни по профилям', 1}, ;
                {' 2. Врачебные приёмы по профилям', 2}, ;
                {' 3. Процедуры и манипуляции', 3}, ;
                {' 4. Лабораторные исследования', 4}, ;
                {' 7. Рентгенологические исследования', 7}, ;
                {' 8. Ультразвуковые исследования', 8}, ;
                {'10. Эндоскопические исследования', 10}, ;
                {'13. Электрокардиографические исследования', 13}, ;
                {'14. Реоэнцефалография', 14}, ;
                {'16. Прочие исследования', 16}, ;
                {'19. Физиотерапевтическое лечение', 19}, ;
                {'20. Лечебная физкультура', 20}, ;
                {'21. Массаж', 21}, ;
                {'22. Рефлексотерапия', 22}, ;
                {'55. Дневные стационары', 55}, ;
                {'56. Прочие услуги', 56}, ;
                {'60. Тарифы на отдельные медицинские услуги', 60}, ;
                {'70. Диспансеризация', 70}, ;
                {'71. Скорая медицинская помощь', 71}, ;
                {'72. Профилактические медицинские осмотры', 72}}
  Local i, ls, sShifr, arr1 := {}, lyear, fl_delete := .t., fl_yes := .f., lal := 'luslc'
  if empty(sdate) .or. sdate != mdate
    lal := create_name_alias(lal, mdate)
  
    Ins_Array(arr, 1,{'КСГ в ДНЕВНОМ стационаре', 502})
    Ins_Array(arr, 1,{'КСГ в СТАЦИОНАРЕ', 501})
  
    use_base('luslc')
    for i := 1 to len(arr)
      if arr[i, 2] > 500
        sShifr := iif(arr[i, 2] == 501, 'st', 'ds')
      else
        sShifr := lstr(arr[i, 2])+'.'
      endif
      ls := len(sShifr)
      dbselectArea(lal)
  
      set order to 1
      find (sShifr)
      do while sShifr == left(&lal.->shifr,ls) .and. !eof()
        if iif(arr[i, 2] > 500, is_ksg(&lal.->shifr), .t.)
          fl_yes := .t.
          // поиск цены по дате окончания лечения
          if between_date(&lal.->datebeg,&lal.->dateend,mdate)
            fl_delete := .f. ; exit
  
          endif
        endif
        skip
      enddo
      if fl_yes .and. !fl_delete
        aadd(arr1,arr[i])
      endif
    next
    close databases
  else
    arr1 := aclone(sarr1)
  endif
  sdate := mdate
  sarr1 := aclone(arr1)
  return arr1
  
// 24.11.21
Function fcena_oms(sShifr, lVzReb, dDate, /*@*/fl_delete, /*@*/fl_yes, /*@*/_ifin)
  Local i, v, tmp_select := select(), lvr, nu, lal, s := glob_mo[_MO_KOD_TFOMS]

  sShifr := padr(sShifr, 10)
  if valtype(dDate) == 'D'
    dDate := {dDate}
  endif
  if !empty(glob_podr) .and. year(dDate[1]) == 2017
    s := padr(glob_podr, 6) // заменяем на код адреса подразделения
  endif
  lvr := iif(lVzReb, 0, 1)
  for i := 1 to len(dDate)
    v := 0
    nu := get2uroven(sShifr, get_uroven(dDate[i]))
    _ifin := 0
    fl_delete := .t.
    fl_yes := .f.
    lal := 'luslc'
    lal := create_name_alias(lal, dDate[i])
    dbselectarea(lal)
    set order to 1
    find (sShifr + str(lvr, 1) + str(glob_otd_dep, 3)) // сначала ищем цену для конкретного отделения
    do while sShifr == &lal.->shifr .and. &lal.->VZROS_REB == lvr .and. &lal.->depart == glob_otd_dep .and. !eof()
      fl_yes := .t.
      if between_date(&lal.->datebeg, &lal.->dateend, dDate[i]) // поиск цены по дате окончания лечения
        fl_delete := .f.
        v := &lal.->CENA
        exit
      endif
      skip
    enddo
    if !fl_yes .and. fl_delete // если не нашли
      find (sShifr + str(lvr, 1) + str(0, 3)) // то ищем цену для depart = 0
      do while sShifr == &lal.->shifr .and. &lal.->VZROS_REB == lvr .and. &lal.->depart == 0 .and. !eof()
        fl_yes := .t.
        if between_date(&lal.->datebeg, &lal.->dateend, dDate[i]) // поиск цены по дате окончания лечения
          fl_delete := .f.
          v := &lal.->CENA
          exit
        endif
        skip
      enddo
    endif
    if empty(v)
      exit
    endif
  next
  select (tmp_select)
  return v

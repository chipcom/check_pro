// check_pro.prg - главный модуль
#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'

external ust_printer, ErrorSys

// 22.07.23
procedure main( ... )
  Local r, s
  Local buf
  local cVar, i

  public Err_version := '' // fs_version(_version()) + ' от ' + _date_version()
  //

  SET(_SET_DELETED, .T.)
  SETCLEARB(' ')
  load_public()
  put_icon(__full_name(), 'MAIN_ICON')
  // set key K_F1 to f_help()
  // hard_err('create')
  FillScreen(p_char_screen, p_color_screen)
  SETCOLOR(color1)

  f_main(r)

  // f_end()
  return

// 22.07.23
FUNCTION load_public()

  REQUEST HB_CODEPAGE_RU866
  HB_CDPSELECT('RU866')
  REQUEST HB_LANG_RU866
  HB_LANGSELECT('RU866')

  REQUEST DBFNTX
  RDDSETDEFAULT('DBFNTX')

  //SET(_SET_EVENTMASK,INKEY_KEYBOARD)
  SET SCOREBOARD OFF
  SET EXACT ON
  SET DATE GERMAN
  SET WRAP ON
  SET CENTURY ON
  SET EXCLUSIVE ON
  SET DELETED ON
  setblink(.f.)

  Public DELAY_SPRD := 0 // время задержки для разворачивания строк
  Public sdbf := '.DBF', sntx := '.NTX', stxt := '.TXT', szip := '.ZIP', ;
    smem := '.MEM', srar := '.RAR', sxml := '.XML', sini := '.INI', ;
    sfr3 := '.FR3', sfrm := '.FRM', spdf := '.PDF', scsv := '.CSV', ;
    sxls := '.xls', schip := '.CHIP', sdbt := '.dbt'
  public cslash := hb_ps()
    
  PUBLIC public_mouse := .f., pravo_write := .t., pravo_read := .t., ;
       MenuTo_Minut := 0, sys_date := DATE(), cScrMode := 'COLOR', ;
       DemoMode := .f., picture_pf := '@R 999-999-999 99', ;
       pict_cena := '9999999.99', forever := 'forever'
  PUBLIC yes_color := .t.

  PUBLIC color0, color1, cColorWait, cColorSt2Msg, cColorStMsg, ;
       cCalcMain, cHelpCMain, cColorText, ;
       cHelpCTitle, cHelpCStatus, cDataCScr, cDataCGet, cDataCSay, ;
       cDataCMenu, color13, color14, cColorSt1Msg, cDataPgDn, col_tit_popup, ;
       color5, color8, col1menu := '', col2menu := '', ;
       color_uch, col_tit_uch
  Public p_color_screen := 'W/N*', p_char_screen := ' ' // заполнение экрана
  Public c__cw := 'N+/N' // цвет теней
  //
  color0 := 'N/BG, W+/N'
  color1 := 'W+/B, W+/R'
  color_uch := 'B/BG, W+/B' ; col_tit_uch := 'B+/BG'
  col1menu := color0 + ', B/BG, BG+/N'
  col2menu := color0 + ', B/BG, BG+/N'
  col_tit_popup := 'B/BG'
  //
  cColorStMsg := 'W+/R, , , , B/W'                 //    Stat_msg
  cColorSt1Msg := 'W+/R, , , , B/W'                //    Stat_msg
  cColorSt2Msg := 'GR+/R, , , , B/W'               //    Stat_msg
  cColorWait := 'W+/R*, , , , B/W'                 //    Ждите
  //
  cCalcMain := 'N/W, GR+/R'                     //    Калькулятор
  //
  cColorText := 'W+/N, BG+/N, , , B/W'
  //
  cHelpCMain := 'W+/RB, W+/N, , , B/W'             //    Помощь
  cHelpCTitle := 'G+/RB'
  cHelpCStatus := 'BG+/RB'
  //                                           //     Ввод данных
  cDataCScr  := 'W+/B, B/BG'
  cDataCGet  := 'W+/B, W+/R, , , BG+/B'
  cDataCSay  := 'BG+/B, W+/R, , , BG+/B'
  cDataCMenu := 'N/BG, W+/N, , , B/W'
  cDataPgDn  := 'BG/B'
  color5     := 'N/W, GR+/R, , , B/W'
  color8     := 'GR+/B, W+/R'
  color13    := 'W/B, W+/R, , , BG+/B'             // некотоpое выделение
  color14    := 'G+/B, W+/R'
  //
  Public dir_server := '', p_name_comp := ''
  
  // проверить, запущена ли уже данная задача, если 'да' - выход из задачи
  // verify_1_task()
  //
  SET KEY K_ALT_F3 TO calendar
  SET KEY K_ALT_F2 TO calc
  SET KEY K_ALT_X  TO f_end
  Public flag_chip := .f.
  READINSERT(.T.) // режим редактирования по умолчанию Insert
  KEYBOARD ''
  ksetnum(.t.)    // включить NumLock
  SETCURSOR(0)
  SET COLOR TO
  RETURN nil

// 22.07.23
Function f_main(r0)
  Static arr1 := {;
    {'Пароли на откат реестров'             , X_PASSWORD, , .t., 'ПАРОЛИ'}, ;
    {'Услуги'                               , X_SERVICE, , .t., 'СПРАВОЧНИК УСЛУГ'}, ;
    {'Обязательное медицинское страхование', X_OMS   , , .t., 'ОМС'}, ;
    {'Учёт направлений на госпитализацию'  , X_263   , , .f., 'ГОСПИТАЛИЗАЦИЯ'}, ;
    {'Платные услуги'                      , X_PLATN , , .t., 'ПЛАТНЫЕ УСЛУГИ'}, ;
    {'Ортопедические услуги в стоматологии', X_ORTO  , , .t., 'ОРТОПЕДИЯ'}, ;
    {'Касса медицинской организации'       , X_KASSA , , .t., 'КАССА'}, ;
    {'КЭК медицинской организации'         , X_KEK   , , .f., 'КЭК'} ;
  }
  Local i, lens := 0, r, c, oldTfoms, arr, ar, k
  local buf
  local a_parol := {}

  PUBLIC array_tasks := {}
  for i := 1 to len(arr1)
    aadd(array_tasks, arr1[i])
    lens := max(lens, len(arr1[i, 1]))
  next

  arr := {}
  Public glob_task, g_arr_stand := {}
      // , blk_ekran
      //  main_menu, main_message, first_menu, ;
      //  first_message, func_menu, cmain_menu
  // вывести верхние строки главного экрана
  r0 := main_up_screen()
  // вывести центральные строки главного экрана
  main_center_screen(r0, a_parol)
    //
  r := int((maxrow() - r0 - len(arr1)) / 2) - 1
  c := int((maxcol() + 1 - lens) / 2) - 1
  // ar := GetIniSect(tmp_ini, 'task')
  // k := i := int(val(a2default(ar, 'current_task', lstr(X_OMS))))
  do while .t.
    if (i := popup_2array(arr1, r + r0, c, i, , , 'Выбор задачи', 'B+/W', 'N+/W, W+/N*')) == 0
      exit
    endif
    buf := savescreen()
    k := i
    prog_menu(i)
    restscreen(buf)
    put_icon(__full_name(), 'MAIN_ICON') // перевывести заголовок окна
    @ r0, 0 say full_date(sys_date) color 'W+/N' // перевывести дату
    @ r0, maxcol() - 4 say hour_min(seconds()) color 'W+/N' // перевывести время
  enddo
  // SetIniSect(tmp_ini, 'task', {{'current_task', lstr(k)}})
  return NIL

// вывести верхние строки главного экрана
Function main_up_screen()
  Local i, k, s, arr[2]

  FillScreen(p_char_screen, p_color_screen) //FillScreen('█','N+/N')
  s := 'Служебная программа'
  @ 0, 0 say padc(s, maxcol() + 1) color 'W+/N'
  k := 1
  // k := perenos(arr, s, maxcol() + 1)
  // for i := 1 to k
  //   @ k, 0 say padc(alltrim(arr[i]), maxcol() + 1) color 'GR+/N'
    @ 1, 0 say padc('', maxcol() + 1) color 'GR+/N'
  // next
  @ k + 1, 0 say space(maxcol() + 1) color 'G+/N'
  @ k + 1, 0 say full_date(sys_date) color 'W+/N'
  @ k + 1, maxcol() - 4 say hour_min(seconds()) color 'W+/N'
  return k + 1

// вывести центральные строки главного экрана
Function main_center_screen(r0, a_parol)
  // Static nLen := 11
  // Static arr_name := {'инфаркт', 'инсульт', 'ЧМТ', 'онкология', ;
  //                   'пневмония', 'язва', 'родовая травма', ;
  //                   'новорожденный с низкой массой тела', ;
  //                   'астма', 'диабет','панкреатит'}
  // Local s, i, c, k, t_arr, r1, buf, mst := ''

  // g_arr_stand := {}
  // if valtype(glob_mo[_MO_STANDART]) == 'A'
  //   for k := 1 to len(glob_mo[_MO_STANDART])
  //     t_arr := {glob_mo[_MO_STANDART,k, 1], {}}
  //     mst := padr(glob_mo[_MO_STANDART,k, 2], nLen)
  //     for i := 1 to nLen
  //       c := substr(mst, i, 1)
  //       if c == '1'
  //         aadd(t_arr[2], i)
  //       endif
  //     next
  //     aadd(g_arr_stand,aclone(t_arr))
  //   next
  // endif
  // if .t.//empty(mst)
  //   if valtype(a_parol) == 'A' .and. (k := len(a_parol)) > 0
  //     r1 := r0 + int((maxrow() - r0 - k) / 2) - 1
  //     n_message(a_parol, , 'W+/W*', 'R/W*', r1, , 'N+/W*')
  //   endif
  // else
  //   s := 'Нозологические формы, по которым МО участвует в выполнении стандартов:'
  //   for i := 1 to nLen
  //     c := substr(mst, i, 1)
  //     if eq_any(c, '1', '2')
  //       s += ' ' + arr_name[i]
  //       if c == '2'
  //         s += '[*]'
  //       endif
  //       s += ','
  //     endif
  //   next
  //   s := left(s, len(s) - 1)
  //   t_arr := array(2)
  //   k := perenos(t_arr, s, 64)
  //   r1 := r0+int((maxrow() - r0 - k) / 2) - 1
  //   if (k := len(a_parol)) > 0
  //     if r1 - r0 < k + 4
  //       r1 := r0 + k + 4
  //     endif
  //     buf := save_box(r1 - k - 4, 0, r1 - 1, maxcol())
  //     f_message(a_parol, , 'W+/W*', 'R/W*', r1 - k - 3)
  //   endif
  //   n_message(t_arr, , 'W/W', 'N/W', r1, , 'N+/W')
  //   if buf != NIL
  //     rest_box(buf)
  //   endif
  // endif
  return NIL

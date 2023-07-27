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

  end_app()
  return

// 27.07.23
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
  Public sdbf := '.DBF', sdbt := '.dbt', sntx := '.NTX', stxt := '.TXT', ;
    smem := '.MEM', sxml := '.XML', sini := '.ini', ;
    sfr3 := '.FR3', sfrm := '.FRM', spdf := '.PDF', scsv := '.CSV', ;
    sxls := '.xls', schip := '.CHIP', szip := '.ZIP', srar := '.RAR'
  public cslash := hb_ps()
    
  PUBLIC public_mouse := .f., pravo_write := .t., pravo_read := .t., ;
       MenuTo_Minut := 0, sys_date := DATE(), cScrMode := 'COLOR', ;
       DemoMode := .f., picture_pf := '@R 999-999-999 99', ;
       pict_cena := '9999999.99', forever := 'forever'
  PUBLIC yes_color := .t.

  Public tmp_ini := cur_dir() + 'tmp' + sini
  Public tools_ini := dir_server() + 'tools' + sini
  Public local_tools_ini := cur_dir() + 'loctools' + sini

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
    {'Услуги'                               , X_SERVICE, , .t., 'СПРАВОЧНИК УСЛУГ'} ;
  }
    // {'Обязательное медицинское страхование', X_OMS   , , .t., 'ОМС'}, ;
    // {'Учёт направлений на госпитализацию'  , X_263   , , .f., 'ГОСПИТАЛИЗАЦИЯ'}, ;
    // {'Платные услуги'                      , X_PLATN , , .t., 'ПЛАТНЫЕ УСЛУГИ'}, ;
    // {'Ортопедические услуги в стоматологии', X_ORTO  , , .t., 'ОРТОПЕДИЯ'}, ;
    // {'Касса медицинской организации'       , X_KASSA , , .t., 'КАССА'}, ;
    // {'КЭК медицинской организации'         , X_KEK   , , .f., 'КЭК'} ;
  Local i, lens := 0, r, c, arr, ar, k
  local buf

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
    //
  r := int((maxrow() - r0 - len(arr1)) / 2) - 1
  c := int((maxcol() + 1 - lens) / 2) - 1

  ar := GetIniSect(tmp_ini, 'task')
  k := i := int(val(a2default(ar, 'current_task', lstr(X_SERVICE))))
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
  SetIniSect(tmp_ini, 'task', {{'current_task', lstr(k)}})
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

// 27.07.23
FUNCTION end_app()
  Static group_ini := 'RAB_MESTO'

  //
	filedelete(cur_dir() + 'tmp*.dbf')
	filedelete(cur_dir() + 'tmp*.ntx')
  // удалим файлы отчетов в формате '*.HTML' из временной директории
  filedelete( HB_DirTemp() + '*.html')
  SET KEY K_ALT_F3 TO
  SET KEY K_ALT_F2 TO
  SET KEY K_ALT_X  TO
  SET COLOR TO
  SET CURSOR ON
  CLS
  QUIT
  RETURN NIL

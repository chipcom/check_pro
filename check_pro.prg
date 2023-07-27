// check_pro.prg - ������ �����
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

  public Err_version := '' // fs_version(_version()) + ' �� ' + _date_version()
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

  Public DELAY_SPRD := 0 // �६� ����প� ��� ࠧ���稢���� ��ப
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
  Public p_color_screen := 'W/N*', p_char_screen := ' ' // ���������� �࠭�
  Public c__cw := 'N+/N' // 梥� ⥭��
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
  cColorWait := 'W+/R*, , , , B/W'                 //    ����
  //
  cCalcMain := 'N/W, GR+/R'                     //    ��������
  //
  cColorText := 'W+/N, BG+/N, , , B/W'
  //
  cHelpCMain := 'W+/RB, W+/N, , , B/W'             //    ������
  cHelpCTitle := 'G+/RB'
  cHelpCStatus := 'BG+/RB'
  //                                           //     ���� ������
  cDataCScr  := 'W+/B, B/BG'
  cDataCGet  := 'W+/B, W+/R, , , BG+/B'
  cDataCSay  := 'BG+/B, W+/R, , , BG+/B'
  cDataCMenu := 'N/BG, W+/N, , , B/W'
  cDataPgDn  := 'BG/B'
  color5     := 'N/W, GR+/R, , , B/W'
  color8     := 'GR+/B, W+/R'
  color13    := 'W/B, W+/R, , , BG+/B'             // �����p�� �뤥�����
  color14    := 'G+/B, W+/R'
  //
  Public dir_server := '', p_name_comp := ''
  
  // �஢����, ����饭� �� 㦥 ������ �����, �᫨ '��' - ��室 �� �����
  // verify_1_task()
  //
  SET KEY K_ALT_F3 TO calendar
  SET KEY K_ALT_F2 TO calc
  SET KEY K_ALT_X  TO f_end
  Public flag_chip := .f.
  READINSERT(.T.) // ०�� ।���஢���� �� 㬮�砭�� Insert
  KEYBOARD ''
  ksetnum(.t.)    // ������� NumLock
  SETCURSOR(0)
  SET COLOR TO
  RETURN nil

// 22.07.23
Function f_main(r0)
  Static arr1 := {;
    {'��஫� �� �⪠� ॥��஢'             , X_PASSWORD, , .t., '������'}, ;
    {'��㣨'                               , X_SERVICE, , .t., '���������� �����'} ;
  }
    // {'��易⥫쭮� ����樭᪮� ���客����', X_OMS   , , .t., '���'}, ;
    // {'���� ���ࠢ����� �� ��ᯨ⠫�����'  , X_263   , , .f., '��������������'}, ;
    // {'����� ��㣨'                      , X_PLATN , , .t., '������� ������'}, ;
    // {'��⮯����᪨� ��㣨 � �⮬�⮫����', X_ORTO  , , .t., '���������'}, ;
    // {'���� ����樭᪮� �࣠����樨'       , X_KASSA , , .t., '�����'}, ;
    // {'��� ����樭᪮� �࣠����樨'         , X_KEK   , , .f., '���'} ;
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
  // �뢥�� ���孨� ��ப� �������� �࠭�
  r0 := main_up_screen()
    //
  r := int((maxrow() - r0 - len(arr1)) / 2) - 1
  c := int((maxcol() + 1 - lens) / 2) - 1

  ar := GetIniSect(tmp_ini, 'task')
  k := i := int(val(a2default(ar, 'current_task', lstr(X_SERVICE))))
  do while .t.
    if (i := popup_2array(arr1, r + r0, c, i, , , '�롮� �����', 'B+/W', 'N+/W, W+/N*')) == 0
      exit
    endif
    buf := savescreen()
    k := i
    prog_menu(i)
    restscreen(buf)
    put_icon(__full_name(), 'MAIN_ICON') // ��ॢ뢥�� ��������� ����
    @ r0, 0 say full_date(sys_date) color 'W+/N' // ��ॢ뢥�� ����
    @ r0, maxcol() - 4 say hour_min(seconds()) color 'W+/N' // ��ॢ뢥�� �६�
  enddo
  SetIniSect(tmp_ini, 'task', {{'current_task', lstr(k)}})
  return NIL

// �뢥�� ���孨� ��ப� �������� �࠭�
Function main_up_screen()
  Local i, k, s, arr[2]

  FillScreen(p_char_screen, p_color_screen) //FillScreen('�','N+/N')
  s := '��㦥���� �ணࠬ��'
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
  // 㤠��� 䠩�� ���⮢ � �ଠ� '*.HTML' �� �६����� ��४�ਨ
  filedelete( HB_DirTemp() + '*.html')
  SET KEY K_ALT_F3 TO
  SET KEY K_ALT_F2 TO
  SET KEY K_ALT_X  TO
  SET COLOR TO
  SET CURSOR ON
  CLS
  QUIT
  RETURN NIL

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

  Public DELAY_SPRD := 0 // �६� ����প� ��� ࠧ���稢���� ��ப
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
    {'��㣨'                               , X_SERVICE, , .t., '���������� �����'}, ;
    {'��易⥫쭮� ����樭᪮� ���客����', X_OMS   , , .t., '���'}, ;
    {'���� ���ࠢ����� �� ��ᯨ⠫�����'  , X_263   , , .f., '��������������'}, ;
    {'����� ��㣨'                      , X_PLATN , , .t., '������� ������'}, ;
    {'��⮯����᪨� ��㣨 � �⮬�⮫����', X_ORTO  , , .t., '���������'}, ;
    {'���� ����樭᪮� �࣠����樨'       , X_KASSA , , .t., '�����'}, ;
    {'��� ����樭᪮� �࣠����樨'         , X_KEK   , , .f., '���'} ;
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
  // �뢥�� ���孨� ��ப� �������� �࠭�
  r0 := main_up_screen()
  // �뢥�� 業�ࠫ�� ��ப� �������� �࠭�
  main_center_screen(r0, a_parol)
    //
  r := int((maxrow() - r0 - len(arr1)) / 2) - 1
  c := int((maxcol() + 1 - lens) / 2) - 1
  // ar := GetIniSect(tmp_ini, 'task')
  // k := i := int(val(a2default(ar, 'current_task', lstr(X_OMS))))
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
  // SetIniSect(tmp_ini, 'task', {{'current_task', lstr(k)}})
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

// �뢥�� 業�ࠫ�� ��ப� �������� �࠭�
Function main_center_screen(r0, a_parol)
  // Static nLen := 11
  // Static arr_name := {'�����', '������', '���', '���������', ;
  //                   '���������', '梨�', 'த���� �ࠢ��', ;
  //                   '����஦����� � ������ ���ᮩ ⥫�', ;
  //                   '��⬠', '������','����ॠ��'}
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
  //   s := '���������᪨� ���, �� ����� �� ������ � �믮������ �⠭���⮢:'
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

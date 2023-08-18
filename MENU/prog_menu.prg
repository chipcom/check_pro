#include 'set.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'

// 23.07.23
Function prog_menu(n_Task)
  Local it, s, k, fl := .t., cNameIcon

  private main_menu := {}
  private main_message := {}
  private first_menu := {}
  private first_message := {}
  private func_menu := {}
  private cmain_menu := {}
  private blk_ekran := {|| devpos(maxrow() - 2, maxcol() - len(dir_server())), ;
                        devout(upper(dir_server()),'W+/N*') }


  sys_date := DATE()
  put_icon(__full_name(), 'MAIN_ICON') // ��ॢ뢥�� ��������� ����
  SETCOLOR(color1)
  FillScreen(p_char_screen, p_color_screen)
  do case
    case n_task == X_PASSWORD
      aadd(cmain_menu, 1)
      aadd(main_menu,' ~��஫� ')
      aadd(main_message,'��楤�� �⬥�� ॣ����樨 ���஭��� ���㬥�⮢ � ����� CHIP_MO')
      aadd(first_menu, {'~������ �� � �� � 㤠������ ��⮢', ;
                        '������ ~��⮢ ����஫�', 0, ;
                        '~�⪠� ���� � ᮧ����� XML-䠩�� ����', ;
                        '~�������� ���� � ��ॢ��⠢����� ��砥�';
                       })
      aadd(first_message, { ;
                          '��஫� ��� �⬥�� ॣ����樨 ॥��� �� � �� � 㤠������ ��⮢', ;
                          '��஫� ��� �⬥�� ॣ����樨 ॥��� ��⮢ ����஫�', ;
                          '��஫� ��� �⬥�� ॣ����樨 ���� � ᮧ����� XML-䠩�� ����', ;
                          '��஫� ��� 㤠����� ���� � ��ॢ��⠢����� ��砥�';
                        })
      aadd(func_menu, {'cre_pas(1)', ;
                       'cre_pas(2)', ;
                       'cre_pas(3)', ;
                       'cre_pas(4)';
                      })
      //
      // aadd(cmain_menu, 34)
      // aadd(main_menu,' ~���ଠ�� ')
      // aadd(main_message,'��ᬮ�� / ����� ����⨪� �� ��樥�⠬')
      // aadd(first_menu, {'����⨪� �� �ਥ~���', ;
      //                   '���ଠ�� �� ~����⥪�', ;
      //                   '~�������ਠ��� ����';
      //                  })
      // aadd(first_message, { ;
      //                     '����⨪� �� ��ࢨ�� ��祡�� �ਥ���', ;
      //                     '��ᬮ�� / ����� ᯨ᪮� �� ��⥣���, ��������, ࠩ����, ���⪠�,...', ;
      //                     '�������ਠ��� ���� � ����⥪�';
      //                     })
      // aadd(func_menu, {'regi_stat()', ;
      //                  'prn_kartoteka()', ;
      //                  'ne_real()' ;
      //                 })
      // //
      // aadd(cmain_menu, 51)
      // aadd(main_menu,' ~��ࠢ�筨�� ')
      // aadd(main_message,'������� �ࠢ�筨���')
      // aadd(first_menu, {'��ࢨ�� ~�ਥ��', 0, ;
      //                   '~����ன�� (㬮�砭��)';
      //                  })
      // aadd(first_message, { ;  // �ࠢ�筨��
      //                     '������஢���� �ࠢ�筨�� �� ��ࢨ�� ��祡�� �ਥ���', ;
      //                     '����ன�� ���祭�� �� 㬮�砭��';
      //                     })
      // aadd(func_menu, {'edit_priem()', ;
      //                  'regi_nastr(2)';
      //                 })
  case n_task == X_SERVICE
    private glob_mo
    public is_otd_dep := .f., glob_otd_dep := 0, mm_otd_dep := {}
    glob_mo := begin_task_services()
    aadd(cmain_menu, 1)
    aadd(main_menu,' ~��㣨 ')
    aadd(main_message,'��ᬮ�� �����⨬�� ��� ��� ����樭᪮� �࣠����樨')
    aadd(first_menu, {'~�஢�ઠ �����⨬��� ��㣨', ;
                      '~���᮪ ���', 0, ;
                      '� ��㣮� ~�⤥�����', 0, ;
                      '~��������'})
    aadd(first_message, {;
        '�஢�ઠ ������ ��㣨 ��� �࣠����樨', ;
        '��ᬮ�� ᯨ᪠ �����⨬�� ���', ;
        '��ॢ�� ���쭮�� �� ������ �⤥����� � ��㣮�', ;
        '�������� ���ਨ �������';
      } )
    aadd(func_menu, {'ne_real()', ;
                     'print_uslugi()', ;
                     'ne_real()', ;
                     'ne_real()'})
  //   aadd(cmain_menu, 34)
  //   aadd(main_menu,' ~���ଠ�� ')
  //   aadd(main_message,'��ᬮ�� / ����� ����⨪� �� �����')
  //   aadd(first_menu, {'~��ୠ� ॣ����樨', ;
  //                     '��ୠ� �� ~������', 0, ;
  //                     '~������� ���ଠ��', 0, ;
  //                     '~��ॢ�� �/� �⤥����ﬨ', 0, ;
  //                     '���� ~�訡��'})
  //   aadd(first_message, {;
  //       '��ᬮ��/����� ��ୠ�� ॣ����樨 ��樮����� ������', ;
  //       '��ᬮ��/����� ��ୠ�� ॣ����樨 ��樮����� ������ �� ������', ;
  //       '������ ������⢠ �ਭ���� ������ � ࠧ������ �� �⤥�����', ;
  //       '����祭�� ���ଠ樨 � ��ॢ��� ����� �⤥����ﬨ', ;
  //       '���� �訡�� �����';
  //     } )
  //   aadd(func_menu, {'pr_gurnal_pp()', ;
  //                    'z_gurnal_pp()', ;
  //                    'pr_svod_pp()', ;
  //                    'pr_perevod_pp()', ;
  //                    'pr_error_pp()'})
  //   aadd(cmain_menu, 51)
  //   aadd(main_menu,' ~��ࠢ�筨�� ')
  //   aadd(main_message,'������� �ࠢ�筨���')
  //   aadd(first_menu, {'~�⮫�', ;
  //                     '~����ன��'})
  //   aadd(first_message, {;
  //       '����� � �ࠢ�筨��� �⮫��', ;
  //       '����ன�� ���祭�� �� 㬮�砭��';
  //     } )
  //   aadd(func_menu, {'f_pp_stol()', ;
  //                    'pp_nastr()'})
  case n_task == X_IMPORT
    aadd(cmain_menu, 1)
    aadd(main_menu,' ~������ �ࠢ�筨���')
    aadd(main_message,'������ �ࠢ�筨��� ��� �ਫ������')
    aadd(first_menu, {'~��ࠢ�筨�� �����', ;
                      '��ࠢ�筨�� ~�����', 0, ;
                      '� ��㣮� ~�⤥�����', 0, ;
                      '~��������'})
    aadd(first_message, {;
        '������ �ࠢ�筨��� ����� ������ࠤ᪮� ������', ;
        '������ �ࠢ�筨��� ����� � sql-䠩�', ;
        '��ॢ�� ���쭮�� �� ������ �⤥����� � ��㣮�', ;
        '�������� ���ਨ �������';
      } )
    aadd(func_menu, {'run_tfomsimport()', ;
                     'run_ffomsimport()', ;
                     'ne_real()', ;
                     'ne_real()'})
  endcase
  aadd(cmain_menu, 30)
  aadd(main_menu,' ~����ன�� ')
  aadd(main_message,'����ன��')
  aadd(first_menu, {'~��騥 ����ன��',0, ;
                    '��ࠢ�筨�� ~�����',0, ;
                    '~����祥 ����'} )
  aadd(first_message, { ;
      '����ன�� �������樨 䠩���', ;
      '����ன�� ᮤ�ন���� �ࠢ�筨��� ����� (㬥��襭�� ������⢠ ��ப)', ;
      '����ன�� ࠡ�祣� ����';
    } )
  aadd(func_menu, {'nastr_convert_files()', ;
                   'ne_real()', ;
                   'ne_real()'} )
  // ��᫥���� ���� ��� ��� ���� � � ��
  // aadd(cmain_menu, maxcol() - 9)
  // aadd(main_menu,' ����~�� ')
  // aadd(main_message, '������, ����ன�� �ਭ��')
  // aadd(first_menu, {'~����� � �ணࠬ��', ;
  //                   '����~��', ;
  //                   '~����祥 ����', ;
  //                   '~�ਭ��', 0, ;
  //                   '��ਭ������ ࠡ�祣� ��⠫���', ;
  //                   '��⥢�� ~������', ;
  //                   '~�訡��'})
  // aadd(first_message, { ;
  //                     '�뢮� �� �࠭ ᮤ�ঠ��� 䠩�� README.RTF � ⥪�⮬ ������ � �ணࠬ��', ;
  //                     '�뢮� �� �࠭ �࠭� �����', ;
  //                     '����ன�� ࠡ�祣� ����', ;
  //                     '��⠭���� ����� �ਭ��', ;
  //                     '��२����஢���� �ࠢ�筨��� ��� � ࠡ�祬 ��⠫���', ;
  //                     '����� ��ᬮ�� - �� ��室���� � ����� � � ����� ०���', ;
  //                     '��ᬮ�� 䠩�� �訡��'})
  // // aadd(func_menu, {'file_Wordpad(exe_dir + cslash + 'README.RTF')', ;
  // aadd(func_menu, {'view_file_in_Viewer(exe_dir + cslash + 'README.RTF')', ;
  //                 'm_help()', ;
  //                 'nastr_rab_mesto()', ;
  //                 'ust_printer(T_ROW)', ;
  //                 'index_work_dir(exe_dir, cur_dir, .t.)', ;
  //                 'net_monitor(T_ROW, T_COL - 7, (hb_user_curUser:IsAdmin()))', ;
  //                 'view_errors()'})
  func_main(.t., blk_ekran)
  return NIL

// 25.05.13 �������� ᫥������ ������ ��� �������� ���� �����
Static Function cmain_next_pos(n)
  
  DEFAULT n TO 5
  return atail(cmain_menu) + len(atail(main_menu)) + n

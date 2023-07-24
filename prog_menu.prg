#include 'set.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include 'chip_mo.ch'

// 23.07.23
Function prog_menu(n_Task)
  Local it, s, k, fl := .t., cNameIcon
  
  glob_task := n_Task
  sys_date := DATE()
  c4sys_date := dtoc4(sys_date)
  blk_ekran := {|| devpos(maxrow() - 2, maxcol() - len(dir_server())), ;
                   devout(upper(dir_server()),'W+/N*') }
  main_menu := {}
  main_message := {}
  first_menu := {}
  first_message := {}
  func_menu := {}
  cmain_menu := {}
  put_icon(__full_name(), 'MAIN_ICON') // ��ॢ뢥�� ��������� ����
  SETCOLOR(color1)
  FillScreen(p_char_screen, p_color_screen)
  do case
    case glob_task == X_REGIST //
      // fl := begin_task_regist()
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
  // case glob_task == X_PPOKOJ  //
  //   fl := begin_task_ppokoj()
  //   aadd(cmain_menu, 1)
  //   aadd(main_menu,' ~���� ����� ')
  //   aadd(main_message,'���� ������ � ��񬭮� ����� ��樮���')
  //   aadd(first_menu, {'~����������', ;
  //                     '~������஢����', 0, ;
  //                     '� ��㣮� ~�⤥�����', 0, ;
  //                     '~��������'})
  //   aadd(first_message, {;
  //       '���������� ���ਨ �������', ;
  //       '������஢���� ���ਨ ������� � ����� ����樭᪮� � ���.�����', ;
  //       '��ॢ�� ���쭮�� �� ������ �⤥����� � ��㣮�', ;
  //       '�������� ���ਨ �������';
  //     } )
  //   aadd(func_menu, {'add_ppokoj()', ;
  //                    'edit_ppokoj()', ;
  //                    'ppokoj_perevod()', ;
  //                    'del_ppokoj()'})
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
  // case glob_task == X_OMS  //
  //   fl := begin_task_oms()
  //   aadd(cmain_menu, 1)
  //   aadd(main_menu,' ~��� ')
  //   aadd(main_message,'���� ������ �� ��易⥫쭮�� ����樭᪮�� ���客����')
  //   aadd(first_menu, {'~����������', ;
  //                     '~������஢����', ;
  //                     '�~����� ��砨', ;
  //                     '����� ~�⤥�����', ;
  //                     '~��������'} )
  //   aadd(first_message, { ;
  //       '���������� ���⪠ ��� ��祭�� ���쭮��', ;
  //       '������஢���� ���⪠ ��� ��祭�� ���쭮��', ;
  //       '����������, ��ᬮ��, 㤠����� ������� ��砥�', ;
  //       '������஢���� ���⪠ ��� ��祭�� ���쭮�� � ᬥ��� �⤥�����', ;
  //       '�������� ���⪠ ��� ��祭�� ���쭮��';
  //     } )
  //   aadd(func_menu, {'oms_add()', ;
  //                    'oms_edit()', ;
  //                    'oms_double()', ;
  //                    'oms_smena_otd()', ;
  //                    'oms_del()'} )
  //   if yes_vypisan == B_END
  //     aadd(first_menu[1], '~�����襭�� ��祭��')
  //     aadd(first_message[1], '������ ࠡ��� � �����襭��� ��祭��')
  //     aadd(func_menu[1], 'oms_zav_lech()')
  //   endif
  //   aadd(first_menu[1], 0)
  //   aadd(first_menu[1], '~����⥪�')
  //   aadd(first_message[1], '����� � ����⥪��')
  //   aadd(func_menu[1], 'oms_kartoteka()')
  //   aadd(first_menu[1], 0)
  //   aadd(first_menu[1],'~��ࠢ�� ���')
  //   aadd(first_message[1],'���� � �ᯥ�⪠ �ࠢ�� � �⮨���� ��������� ����樭᪮� ����� � ��� ���')
  //   aadd(func_menu[1],'f_spravka_OMS()')
  //   //
  //   aadd(first_menu[1], 0)
  //   aadd(first_menu[1],'��������� ~業 ���')
  //   aadd(first_message[1],'��������� 業 �� ��㣨 � ᮮ⢥��⢨� � �ࠢ�筨��� ��� �����')
  //   aadd(func_menu[1],'Change_Cena_OMS()')
  //   //
  //   aadd(cmain_menu,cmain_next_pos(3))
  //   aadd(main_menu,' ~������� ')
  //   aadd(main_message,'����, ����� � ��� ॥��஢ ��砥�')
  //   aadd(first_menu, {'��~��ઠ', ;
  //                     '~���⠢�����', ;
  //                     '~��ᬮ��', 0, ;
  //                     '��~����', 0})
  //   aadd(first_message, { ;
  //       '�஢�ઠ ��। ��⠢������ ॥��� ��砥�', ;
  //       '���⠢����� ॥��� ��砥�', ;
  //       '��ᬮ�� ॥��� ��砥�, ��ࠢ�� � �����', ;
  //       '������ ॥��� ��砥�'})
  //   aadd(func_menu, {'verify_OMS()', ;
  //                    'create_reestr()', ;
  //                    'view_list_reestr()', ;
  //                    'vozvrat_reestr()'})
  //   if glob_mo[_MO_IS_UCH]
  //     aadd(first_menu[2], '�~ਪ९�����')
  //     aadd(first_message[2], '��ᬮ�� 䠩��� �ਪ९����� (� �⢥⮢ �� ���), ������ 䠩��� ��� �����')
  //     aadd(func_menu[2], 'view_reestr_pripisnoe_naselenie()')
  //     aadd(first_menu[2], '~��९�����')
  //     aadd(first_message[2], '��ᬮ�� ����祭��� �� ����� 䠩��� ��९�����')
  //     aadd(func_menu[2], 'view_otkrep_pripisnoe_naselenie()')
  //   endif
  //   aadd(first_menu[2], '~����⠩�⢠')
  //   aadd(first_message[2], '��ᬮ��, ������ � �����, 㤠����� 䠩��� 室�⠩��')
  //   aadd(func_menu[2], 'view_list_hodatajstvo()')
  //   //
  //   aadd(cmain_menu,cmain_next_pos(3))
  //   aadd(main_menu,' ~��� ')
  //   aadd(main_message,'��ᬮ��, ����� � ��� ��⮢ �� ���')
  //   aadd(first_menu, {'~�⥭�� �� �����', ;
  //                     '���᮪ ~��⮢', ;
  //                     '~���������', ;
  //                     '~���� ����஫�', ;
  //                     '������ ~���㬥���', 0, ;
  //                     '~��稥 ���'} )
  //   aadd(first_message, { ;
  //       '�⥭�� ���ଠ樨 �� ����� (�� ���)', ;
  //       '��ᬮ�� ᯨ᪠ ��⮢ �� ���, ������ ��� �����, ����� ��⮢', ;
  //       '�⬥⪠ � ॣ����樨 ��⮢ � �����', ;
  //       '����� � ��⠬� ����஫� ��⮢ (� ॥��ࠬ� ��⮢ ����஫�)', ;
  //       '����� � �����묨 ���㬥�⠬� �� ����� (� ॥��ࠬ� ������� ���㬥�⮢)', ;
  //       '����� � ��稬� ��⠬� (ᮧ�����, ।���஢����, ������)', ;
  //     } )
  //   aadd(func_menu, {'read_from_tf()', ;
  //                    'view_list_schet()', ;
  //                    'registr_schet()', ;
  //                    'akt_kontrol()', ;
  //                    'view_pd()', ;
  //                    'other_schets()'} )
  //   //
  //   aadd(cmain_menu,cmain_next_pos(3))
  //   aadd(main_menu,' ~���ଠ�� ')
  //   aadd(main_message,'��ᬮ�� / ����� ���� �ࠢ�筨��� � ����⨪�')
  //   aadd(first_menu, {'���� ~���', ;
  //                     '~����⨪�', ;
  //                     '����-~�����', ;
  //                     '~�஢�ન', ;
  //                     '��ࠢ�~筨��', 0, ;
  //                     '����� ~�������'} )
  //   aadd(first_message, { ;
  //       '��ᬮ�� / ����� ���⮢ ��� ������', ;
  //       '��ᬮ�� / ����� ����⨪�', ;
  //       '����⨪� �� ����-������', ;
  //       '������� �஢�ન', ;
  //       '��ᬮ�� / ����� ���� �ࠢ�筨���', ;
  //       '��ᯥ�⪠ �ᥢ�������� �������';
  //     } )
  //   aadd(func_menu, {'o_list_uch()', ;
  //                    'e_statist()', ;
  //                    'pz_statist()', ;
  //                    'o_proverka()', ;
  //                    'o_sprav()', ;
  //                    'prn_blank()'} )
  //   if yes_parol
  //     aadd(first_menu[4], '����� ~�����஢')
  //     aadd(first_message[4], '����⨪� �� ࠡ�� �����஢ �� ���� � �� �����')
  //     aadd(func_menu[4], 'st_operator()')
  //   endif
  //   //
  //   aadd(cmain_menu,cmain_next_pos(3))
  //   aadd(main_menu,' ~��ᯠ��ਧ��� ')
  //   aadd(main_message,'��ᯠ��ਧ���, ��䨫��⨪�, ����ᬮ��� � ��ᯠ��୮� �������')
  //   aadd(first_menu, {'~��ᯠ��ਧ��� � ���ᬮ���', 0, ;
  //                     '��ᯠ��୮� ~�������'} )
  //   aadd(first_message, { ;
  //       '��ᯠ��ਧ���, ��䨫��⨪� � ����ᬮ���', ;
  //       '��ᯠ��୮� �������';
  //     } )
  //   aadd(func_menu, {'dispanserizacia()', ;
  //                    'disp_nabludenie()'} ) 
  // case glob_task == X_263 //
  //   fl := begin_task_263()
  //   if is_napr_pol
  //     aadd(cmain_menu, 1)
  //     aadd(main_menu,' ~����������� ')
  //     aadd(main_message,'���� / ।���஢���� ���ࠢ����� �� ��ᯨ⠫����� �� �����������')
  //     aadd(first_menu, {;//'~�஢�ઠ', 0, ;
  //                       '~���ࠢ�����', ;
  //                       '~���㫨஢����', ;
  //                       '~���ନ஢����', 0, ;
  //                       '~�������� �����', 0, ;
  //                       '~����⥪�'} )
  //     aadd(first_message, { ;//'�஢�ઠ ⮣�, �� ��� �� ᤥ���� � �����������', ;
  //         '���� / ।���஢���� / ��ᬮ�� ���ࠢ����� �� ��ᯨ⠫����� �� �����������', ;
  //         '���㫨஢���� �믨ᠭ��� ���ࠢ����� �� ��ᯨ⠫����� �� �����������', ;
  //         '���ନ஢���� ���� ��樥�⮢ � ��� �।���饩 ��ᯨ⠫���樨', ;
  //         '��ᬮ�� ������⢠ ᢮������ ���� �� ��䨫� � ��樮����/������� ��樮����', ;
  //         '����� � ����⥪��';
  //       } )
  //     aadd(func_menu, {;//'_263_p_proverka()', ;
  //                      '_263_p_napr()', ;
  //                      '_263_p_annul()', ;
  //                      '_263_p_inform()', ;
  //                      '_263_p_svob_kojki()', ;
  //                      '_263_kartoteka(1)'} )
  //   endif
  //   if is_napr_stac
  //     aadd(cmain_menu, 15)
  //     aadd(main_menu,' ~��樮��� ')
  //     aadd(main_message,'���� ���� ��ᯨ⠫���樨, ���� ��ᯨ⠫���஢����� � ����� �� ��樮����')
  //     aadd(first_menu, {;//'~�஢�ઠ', 0, ;
  //                       '~��ᯨ⠫���樨', ;
  //                       '~�믨᪠ (���⨥)', ;
  //                       '~���ࠢ�����', ;
  //                       '~���㫨஢����', 0, ;
  //                       '~�������� �����', 0, ;
  //                       '~����⥪�'} )
  //     aadd(first_message, { ;// '�஢�ઠ ⮣�, �� ��� �� ᤥ���� � ��樮���', ;
  //         '���������� / ।���஢���� ��ᯨ⠫���権 � ��樮���', ;
  //         '�믨᪠ (���⨥) ��樥�� �� ��樮���', ;
  //         '���᮪ ���ࠢ�����, �� ����� ��� �� �뫮 ��ᯨ⠫���樨', ;
  //         '���㫨஢���� ���ࠢ�����, ����㯨��� �� ���������� �१ �����', ;
  //         '���� / ।���஢���� ������⢠ ᢮������ ���� �� ��䨫� � ��樮���', ;
  //         '����� � ����⥪��';
  //       } )
  //     aadd(func_menu, {;//'_263_s_proverka()', ;
  //                      '_263_s_gospit()', ;
  //                      '_263_s_vybytie()', ;
  //                      '_263_s_napr()', ;
  //                      '_263_s_annul()', ;
  //                      '_263_s_svob_kojki()', ;
  //                      '_263_kartoteka(2)'} )
  //   endif
  //   aadd(cmain_menu, 29)
  //   aadd(main_menu,' ~� ����� ')
  //   aadd(main_message,'��ࠢ�� � ����� 䠩��� ������ (��ᬮ�� ��ࠢ������ 䠩���)')
  //   aadd(first_menu, {'~�஢�ઠ ��। ��⠢������ ����⮢', ;
  //                     '~���⠢����� ����⮢ ��� ��ࠢ�� � ��', ;
  //                     '��ᬮ�� ��⮪���� ~�����', 0})
  //   aadd(first_message,  { ;   // ���ଠ��
  //         '�஢�ઠ ���ଠ樨 ��। ��⠢������ ����⮢ � ��ࠢ��� � �����', ;
  //         '���⠢����� ���ଠ樮���� ����⮢ ��� ��ࠢ�� � �����', ;
  //         '��ᬮ�� ��⮪���� ��⠢����� ���ଠ樮���� ����⮢ ��� ��ࠢ�� � �����';
  //        })
  //   aadd(func_menu, {;    // ���ଠ��
  //         '_263_to_proverka()', ;
  //         '_263_to_sostavlenie()', ;
  //         '_263_to_protokol()';
  //        })
  //   k := len(first_menu)
  //   if is_napr_pol
  //     aadd(first_menu[k], 'I0~1-�믨ᠭ�� ���ࠢ�����')
  //     aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � �믨ᠭ�묨 ���ࠢ����ﬨ')
  //     aadd(func_menu[k], '_263_to_I01()')
  //   endif
  //   aadd(first_menu[k], 'I0~3-���㫨஢���� ���ࠢ�����')
  //   aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ���㫨஢���묨 ���ࠢ����ﬨ')
  //   aadd(func_menu[k], '_263_to_I03()')
  //   if is_napr_stac
  //     aadd(first_menu[k], 'I0~4-��ᯨ⠫���樨 �� ���ࠢ�����')
  //     aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ��ᯨ⠫����ﬨ �� ���ࠢ�����')
  //     aadd(func_menu[k], '_263_to_I04(4)')
  //     //
  //     aadd(first_menu[k], 'I0~5-���७�� ��ᯨ⠫���樨')
  //     aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ��ᯨ⠫����ﬨ ��� ���ࠢ����� (����.� ����.)')
  //     aadd(func_menu[k], '_263_to_I04(5)')
  //     //
  //     aadd(first_menu[k], 'I0~6-���訥 ��樥���')
  //     aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ᢥ����ﬨ � ����� ��樥���')
  //     aadd(func_menu[k], '_263_to_I06()')
  //   endif
  //   aadd(first_menu[k], 0)
  //   aadd(first_menu[k], '~����ன�� ��⠫����')
  //   aadd(first_message[k], '����ன�� ��⠫���� ������ - �㤠 �����뢠�� ᮧ����� ��� ����� 䠩��')
  //   aadd(func_menu[k], '_263_to_nastr()')
  //   //
  //   aadd(cmain_menu, 39)
  //   aadd(main_menu,' �� ~����� ')
  //   aadd(main_message,'����祭�� �� ����� 䠩��� ������ � ��ᬮ�� ����祭��� 䠩���')
  //   aadd(first_menu, {'~�⥭�� �� �����', ;
  //                     '~��ᬮ�� ��⮪���� �⥭��', 0})
  //   aadd(first_message,  { ;   // ���ଠ��
  //         '����祭�� �� ����� 䠩��� ������ (���ଠ樮���� ����⮢)', ;
  //         '��ᬮ�� ��⮪���� �⥭�� ���ଠ樮���� ����⮢ �� �����';
  //        })
  //   aadd(func_menu, {;
  //         '_263_from_read()', ;
  //         '_263_from_protokol()';
  //        })
  //   k := len(first_menu)
  //   if is_napr_stac
  //     aadd(first_menu[k], 'I0~1-����祭�� ���ࠢ�����')
  //     aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ����祭�묨 ���ࠢ����ﬨ �� ����������')
  //     aadd(func_menu[k], '_263_from_I01()')
  //   endif
  //   aadd(first_menu[k], 'I0~3-���㫨஢���� ���ࠢ�����')
  //   aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ���㫨஢���묨 ���ࠢ����ﬨ')
  //   aadd(func_menu[k], '_263_from_I03()')
  //   if is_napr_pol
  //     aadd(first_menu[k], 'I0~4-��ᯨ⠫���樨 �� ���ࠢ�����')
  //     aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ��ᯨ⠫����ﬨ �� ���ࠢ�����')
  //     aadd(func_menu[k], '_263_from_I04()')
  //     //
  //     aadd(first_menu[k], 'I0~5-���७�� ��ᯨ⠫���樨')
  //     aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ��ᯨ⠫����ﬨ ��� ���ࠢ����� (����.� ����.)')
  //     aadd(func_menu[k], '_263_from_I05()')
  //     //
  //     aadd(first_menu[k], 'I0~6-���訥 ��樥���')
  //     aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ᢥ����ﬨ � ����� ��樥���')
  //     aadd(func_menu[k], '_263_from_I06()')
  //     //
  //     aadd(first_menu[k], 'I0~7-����稥 ᢮������ ����')
  //     aadd(first_message[k], '���᮪ ���ଠ樮���� ����⮢ � ᢥ����ﬨ � ����稨 ᢮������ ����')
  //     aadd(func_menu[k], '_263_from_I07()')
  //   endif
  //   aadd(first_menu[k], 0)
  //   aadd(first_menu[k], '~����ன�� ��⠫����')
  //   aadd(first_message[k], '����ன�� ��⠫���� ������ - ��㤠 ����뢠�� ����祭�� �� ����� 䠩��')
  //   aadd(func_menu[k], '_263_to_nastr()')
  //   //
  // case glob_task == X_PLATN //
  //   fl := begin_task_plat()
  //   aadd(cmain_menu, 1)
  //   aadd(main_menu,' ~����� ��㣨 ')
  //   aadd(main_message,'���� / ।���஢���� ������ �� ���⮢ ��� ������ ����樭᪨� ���')
  //   aadd(first_menu, {'~���� ������'} )
  //   aadd(first_message, {'����������/������஢���� ���⪠ ��� ��祭�� ���⭮�� ���쭮��'} )
  //   aadd(func_menu, {'kart_plat()'} )
  //   if glob_pl_reg == 1
  //     aadd(first_menu[1], '~����/।-��')
  //     aadd(first_message[1], '����/������஢���� ���⮢ ��� ��祭�� ������ ������')
  //     aadd(func_menu[1], 'poisk_plat()')
  //   endif
  //   aadd(first_menu[1], 0)
  //   aadd(first_menu[1], '~����⥪�')
  //   aadd(first_message[1], '����� � ����⥪��')
  //   aadd(func_menu[1], 'oms_kartoteka()')
  //   aadd(first_menu[1], 0)
  //   aadd(first_menu[1], '~����� ��� � �/�')
  //   aadd(first_message[1], '����/।���஢���� ����� �� ����������� � ���஢��쭮�� ���.���客����')
  //   aadd(func_menu[1], 'oplata_vz()')
  //   aadd(first_menu[1], 0)
  //   aadd(first_menu[1], '~�����⨥ �/���')
  //   aadd(first_message[1], '������� ���� ��� (���� �ਧ��� ������� � ���� ���)')
  //   aadd(func_menu[1], 'close_lu()')
  //   //
  //   aadd(cmain_menu, 34)
  //   aadd(main_menu,' ~���ଠ�� ')
  //   aadd(main_message,'��ᬮ�� / ����� ���� �ࠢ�筨��� � ����⨪�')
  //   aadd(first_menu, {'~����⨪�', ;
  //                     '���~��筨��', ;
  //                     '~�஢�ન'})
  //   aadd(first_message,  { ;   // ���ଠ��
  //         '��ᬮ�� ����⨪�', ;
  //         '��ᬮ�� ���� �ࠢ�筨���', ;
  //         '������� �஢���� ०���';
  //        })
  //   aadd(func_menu, {;    // ���ଠ��
  //         'Po_statist()', ;
  //         'o_sprav()', ;
  //         'Po_proverka()';
  //        })
  //   if glob_kassa == 1
  //     aadd(first_menu[2], 0)
  //     aadd(first_menu[2], '����� � ~���ᮩ')
  //     aadd(first_message[2], '���ଠ�� �� ࠡ�� � ���ᮩ')
  //     aadd(func_menu[2], 'inf_fr()')
  //   endif
  //   if yes_parol
  //     aadd(first_menu[2], 0)
  //     aadd(first_menu[2], '����� ~�����஢')
  //     aadd(first_message[2], '����⨪� �� ࠡ�� �����஢ �� ���� � �� �����')
  //     aadd(func_menu[2], 'st_operator()')
  //   endif
  //   //
  //   aadd(cmain_menu, 50)
  //   aadd(main_menu,' ~��ࠢ�筨�� ')
  //   aadd(main_message,'������� �ࠢ�筨���')
  //   aadd(first_menu,{})
  //   aadd(first_message,{})
  //   aadd(func_menu,{})
  //   if is_oplata != 7
  //     aadd(first_menu[3], '~��������')
  //     aadd(first_message[3], '��ࠢ�筨� ������� ��� ������ ���')
  //     aadd(func_menu[3], 's_pl_meds(1)')
  //     //
  //     aadd(first_menu[3], '~�����ન')
  //     aadd(first_message[3], '��ࠢ�筨� ᠭ��ப ��� ������ ���')
  //     aadd(func_menu[3], 's_pl_meds(2)')
  //   endif
  //   aadd(first_menu[3], '�।����� (�/~����)')
  //   aadd(first_message[3], '��ࠢ�筨� �।���⨩, ࠡ����� �� �����������')
  //   aadd(func_menu[3], 'edit_pr_vz()')
  //   //
  //   aadd(first_menu[3], '~���஢���� ���') ; aadd(first_menu[3], 0)
  //   aadd(first_message[3], '��ࠢ�筨� ���客�� ��������, �����⢫���� ���஢��쭮� ���.���客����')
  //   aadd(func_menu[3], 'edit_d_smo()')
  //   //
  //   aadd(first_menu[3], '��㣨 �� ���~�')
  //   aadd(first_message[3], '������஢���� �ࠢ�筨�� ���, 業� �� ����� ������� � �����-� ����')
  //   aadd(func_menu[3], 'f_usl_date()')
  //   if glob_kassa == 1
  //     aadd(first_menu[3], 0)
  //     aadd(first_menu[3], '����� � ~���ᮩ')
  //     aadd(first_message[3], '����ன�� ࠡ��� � ���ᮢ� �����⮬')
  //     aadd(func_menu[3], 'fr_nastrojka()')
  //   endif
  // case glob_task == X_ORTO  //
  //   fl := begin_task_orto()
  //   aadd(cmain_menu, 1)
  //   aadd(main_menu,' ~��⮯���� ')
  //   aadd(main_message,'���� ������ �� ��⮯����᪨� ��㣠� � �⮬�⮫����')
  //   aadd(first_menu, {'~����⨥ ���鸞', ;
  //                     '~�����⨥ ���鸞', 0, ;
  //                     '~����⥪�'})
  //   aadd(first_message,  {;
  //        '����⨥ ���鸞-������ (���������� ���⪠ ��� ��祭�� ���쭮��)', ;
  //        '�����⨥ ���鸞-������ (।���஢���� ���⪠ ��� ��祭�� ���쭮��)', ;
  //        '����� � ����⥪��'} )
  //   aadd(func_menu, {'kart_orto(1)', ;
  //                    'kart_orto(2)', ;
  //                    'oms_kartoteka()'})
  //   //
  //   aadd(cmain_menu, 34)
  //   aadd(main_menu,' ~���ଠ�� ')
  //   aadd(main_message,'��ᬮ�� / ����� ���� �ࠢ�筨��� � ����⨪�')
  //   aadd(first_menu, {'~����⨪�', ;
  //                     '���~��筨��', ;
  //                     '~�஢�ન'})
  //   aadd(first_message,  { ;   // ���ଠ��
  //         '��ᬮ�� ����⨪�', ;
  //         '��ᬮ�� ���� �ࠢ�筨���', ;
  //         '������� �஢���� ०���';
  //        })
  //   aadd(func_menu, {;    // ���ଠ��
  //         'Oo_statist()', ;
  //         'o_sprav(-5)', ;   // X_ORTO = 5
  //         'Oo_proverka()';
  //        })
  //   if glob_kassa == 1   //10.10.14
  //     aadd(first_menu[2], 0)
  //     aadd(first_menu[2], '����� � ~���ᮩ')
  //     aadd(first_message[2], '���ଠ�� �� ࠡ�� � ���ᮩ')
  //     aadd(func_menu[2], 'inf_fr_orto()')
  //   endif
  //   if yes_parol
  //     aadd(first_menu[2], 0)
  //     aadd(first_menu[2], '����� ~�����஢')
  //     aadd(first_message[2], '����⨪� �� ࠡ�� �����஢ �� ���� � �� �����')
  //     aadd(func_menu[2], 'st_operator()')
  //   endif
  //   //
  //   aadd(cmain_menu, 50)
  //   aadd(main_menu,' ~��ࠢ�筨�� ')
  //   aadd(main_message,'������� �ࠢ�筨���')
  //   aadd(first_menu, ;
  //     {'��⮯����᪨� ~��������', ;
  //      '��稭� ~�������', ;
  //      '~��㣨 ��� ��祩', 0, ;
  //      '�।����� (�/~����)', ;
  //      '~���஢���� ���', 0, ;
  //      '~���ਠ��';
  //     })
  //   aadd(first_message, ;
  //     {'������஢���� �ࠢ�筨�� ��⮯����᪨� ���������', ;
  //      '������஢���� �ࠢ�筨�� ��稭 ������� ��⥧��', ;
  //      '����/।���஢���� ���, � ������ �� �������� ��� (�孨�)', ;
  //      '��ࠢ�筨� �।���⨩, ࠡ����� �� �����������', ;
  //      '��ࠢ�筨� ���客�� ��������, �����⢫���� ���஢��쭮� ���.���客����', ;
  //      '��ࠢ�筨� �ਢ������� ��室㥬�� ���ਠ���';
  //     })
  //   aadd(func_menu, ;
  //     {'orto_diag()', ;
  //      'f_prich_pol()', ;
  //      'f_orto_uva()', ;
  //      'edit_pr_vz()', ;
  //      'edit_d_smo()', ;
  //      'edit_ort()';
  //     })
  //   if glob_kassa == 1
  //     aadd(first_menu[3], 0)
  //     aadd(first_menu[3], '����� � ~���ᮩ')
  //     aadd(first_message[3], '����ன�� ࠡ��� � ���ᮢ� �����⮬')
  //     aadd(func_menu[3], 'fr_nastrojka()')
  //   endif
  // case glob_task == X_KASSA //
  //   fl := begin_task_kassa()
  //   //
  //   aadd(cmain_menu, 1)
  //   aadd(main_menu,' ~���� �� ')
  //   aadd(main_message,'���� ������ � ���� �� �� ����� ��㣠�')
  //   aadd(first_menu, {'~���� ������', 0, ;
  //                     '~����⥪�'})
  //   aadd(first_message,  {;
  //        '���������� ���⪠ ��� ��祭�� ���⭮�� ���쭮��', ;
  //        '����/।���஢���� ����⥪� (ॣ�������)'})
  //   aadd(func_menu, {'kas_plat()', ;
  //                    'oms_kartoteka()'})
  //   aadd(first_menu[1], 0)
  //   aadd(first_menu[1],'~��ࠢ�� ���')
  //   aadd(first_message[1],'���� � �ᯥ�⪠ �ࠢ�� � �⮨���� ��������� ����樭᪮� ����� � ��� ���')
  //   aadd(func_menu[1],'f_spravka_OMS()')
  //   //
  //   if is_task(X_ORTO)
  //     aadd(cmain_menu,cmain_next_pos())
  //     aadd(main_menu,' ~��⮯���� ')
  //     aadd(main_message,'���� ������ �� ��⮯����᪨� ��㣠�')
  //     aadd(first_menu,{'~���� ����', ;
  //                      '~������஢���� ���鸞', 0, ;
  //                      '~����⥪�'})
  //     aadd(first_message,{;
  //          '����⨥ ᫮����� ���鸞 ��� ���� ���⮣� ��⮯����᪮�� ���鸞', ;
  //          '������஢���� ��⮯����᪮�� ���鸞 (� �.�. ������ ��� ������ �����)', ;
  //          '����/।���஢���� ����⥪� (ॣ�������)'})
  //     aadd(func_menu,{'f_ort_nar(1)', ;
  //                     'f_ort_nar(2)', ;
  //                     'oms_kartoteka()'})
  //   endif
  //   //
  //   aadd(cmain_menu,cmain_next_pos())
  //   aadd(main_menu,' ~���ଠ�� ')
  //   aadd(main_message,'��ᬮ�� / �����')
  //   aadd(first_menu, {iif(is_task(X_ORTO),'~����� ��㣨','~����⨪�'), ;
  //                     '������� �~���⨪�', ; //10.05
  //                     '���~��筨��', ;
  //                     '����� � ~���ᮩ'})
  //   aadd(first_message,  { ;   // ���ଠ��
  //         '��ᬮ�� / ����� ������᪨� ���⮢ �� ����� ��㣠�', ;
  //         '��ᬮ�� / ����� ᢮���� ������᪨� ���⮢', ;
  //         '��ᬮ�� ���� �ࠢ�筨���', ;
  //         '���ଠ�� �� ࠡ�� � ���ᮩ';
  //        })
  //   aadd(func_menu, {;    // ���ଠ��
  //         'prn_k_plat()', ;
  //         'regi_s_plat()', ;
  //         'o_sprav()', ;
  //         'prn_k_fr()';
  //        })
  //   if is_task(X_ORTO)
  //     Ins_Array(first_menu[3], 2,'~��⮯����')
  //     Ins_Array(first_message[3], 2,'��ᬮ�� / ����� ������᪨� ���⮢ �� ��⮯����')
  //     Ins_Array(func_menu[3], 2,'prn_k_ort()')
  //   endif
  //   //
  //   aadd(cmain_menu,cmain_next_pos())
  //   aadd(main_menu,' ~��ࠢ�筨�� ')
  //   aadd(main_message,'��ᬮ�� / ।���஢���� �ࠢ�筨���')
  //   aadd(first_menu,{'~��㣨 � ᬥ��� 業�', ;
  //                    '~������ ��㣨', ;
  //                    '����� � ~���ᮩ', 0, ;
  //                    '~����ன�� �ணࠬ��'})
  //   aadd(first_message,{;
  //        '������஢���� ᯨ᪠ ���, �� ����� ������ ࠧ�蠥��� ।���஢��� 業�', ;
  //        '������஢���� ᯨ᪠ ���, �� �뢮����� � ��ୠ� ������஢ (�᫨ 1 � 祪�)', ;
  //        '����ன�� ࠡ��� � ���ᮢ� �����⮬', ;
  //        '����ன�� �ணࠬ�� (�������� ���祭�� �� 㬮�砭��)'})
  //   aadd(func_menu,{'fk_usl_cena()', ;
  //                   'fk_usl_dogov()', ;
  //                   'fr_nastrojka()', ;
  //                   'nastr_kassa(2)'})
  // case glob_task == X_KEK  //
  //   if !between(hb_user_curUser:KEK, 1, 3)
  //     n_message({'�������⨬�� ��㯯� �ᯥ�⨧� (���): '+lstr(hb_user_curUser:KEK), ;
  //                '', ;
  //                '���짮��⥫�, ����� ࠧ�襭� ࠡ���� � �������� "��� ��",', ;
  //                '����室��� ��⠭����� ��㯯� �ᯥ�⨧� (�� 1 �� 3)', ;
  //                '� �������� "������஢���� �ࠢ�筨���" � ०��� "��ࠢ�筨��/��஫�"'}, , ;
  //               'GR+/R','W+/R', ,,'G+/R')
  //   else
  //     fl := begin_task_kek()
  //     aadd(cmain_menu, 1)
  //     aadd(main_menu,' ~��� ')
  //     aadd(main_message,'���� ������ �� ��� ����樭᪮� �࣠����樨')
  //     aadd(first_menu, {'~����������', ;
  //                       '~������஢����', ;
  //                       '~��������'} )
  //     aadd(first_message, { ;
  //         '���������� ������ �� ���⨧�', ;
  //         '������஢���� ������ �� ���⨧�', ;
  //         '�������� ������ �� ���⨧�';
  //       } )
  //     aadd(func_menu, {'kek_vvod(1)', ;
  //                      'kek_vvod(2)', ;
  //                      'kek_vvod(3)'} )
  //     aadd(cmain_menu, 34)
  //     aadd(main_menu,' ~���ଠ�� ')
  //     aadd(main_message,'��ᬮ�� / ����� ����⨪� �� �ᯥ�⨧��')
  //     aadd(first_menu, {'~��ᯥ�⭠� ����', ;
  //                       '�業�� ~����⢠'} )
  //     aadd(first_message, {;
  //         '��ᯥ�⪠ �ᯥ�⭮� �����', ;
  //         '��ᯥ�⪠ ࠫ���� ����⮢ �� �楪� ����⢠ �ᯥ�⨧�'} )
  //     aadd(func_menu, {'kek_prn_eks()', ;
  //                      'kek_info2017()'})
  //     aadd(cmain_menu, 51)
  //     aadd(main_menu,' ~��ࠢ�筨�� ')
  //     aadd(main_message,'������� �ࠢ�筨���')
  //     aadd(first_menu, {'~����ன��'})
  //     aadd(first_message, {'����ன�� ���祭�� �� 㬮�砭��'} )
  //     aadd(func_menu, {'kek_nastr()'})
  //   endif
  // case glob_task == X_SPRAV //
  //   fl := begin_task_sprav()
  //   //
  //   aadd(cmain_menu, 1)
  //   aadd(main_menu,' ~��ࠢ�筨�� ')
  //   aadd(main_message,'������஢���� �ࠢ�筨���')
  //   aadd(first_menu, {'~������� �࣠����樨', ;
  //                     '��ࠢ�筨� ~���', ;
  //                     '�~�稥 �ࠢ�筨��';
  //                     })
  //   aadd(first_message, { ;
  //       '������஢���� �ࠢ�筨��� ���ᮭ���, �⤥�����, ��०�����, �࣠����樨', ;
  //       '������஢���� �ࠢ�筨�� ���', ;
  //       '������஢���� ���� �ࠢ�筨���'; //, ;
  //       } )
  //   aadd(func_menu, {'spr_struct_org()', ;
  //                    'edit_spr_uslugi()', ;
  //                    'edit_proch_spr()';
  //                    } )
  //   //
  //   // �����ன�� ����
  //   if hb_user_curUser:ID !=0 .or. hb_user_curUser:IsSuperUser()
  //     hb_AIns( first_menu[ len( first_menu ) ], 4, 0, .t. )
  //     hb_AIns( first_menu[ len( first_menu ) ], 5, '~���짮��⥫�', .t. )
  //     hb_AIns( first_menu[ len( first_menu ) ], 6, '~��㯯� ���짮��⥫��', .t. )
  //     hb_AIns( first_message[ len( first_message ) ], 4, '������஢���� �ࠢ�筨�� ���짮��⥫�� ��⥬�', .t. )
  //     hb_AIns( first_message[ len( first_message ) ], 5, '������஢���� �ࠢ�筨�� ��㯯 ���짮��⥫�� � ��⥬�', .t. )
  //     if hb_main_curOrg:KOD_TFOMS == '102604'
  //       hb_AIns( func_menu[ len( func_menu ) ], 4, 'edit_Users_bay()', .t. )
  //     else
  //       hb_AIns( func_menu[ len( func_menu ) ], 4, 'edit_password()', .t. )
  //     endif
  //     hb_AIns( func_menu[ len( func_menu ) ], 5, 'editRoles()', .t. )
  //   endif
  //   // ����� �����ன�� ����

  //   aadd(cmain_menu, 40)
  //   aadd(main_menu,' ~���ଠ�� ')
  //   aadd(main_message,'��ᬮ��/����� �ࠢ�筨���')
  //   aadd(first_menu, {'~��騥 �ࠢ�筨��'} )
  //   aadd(first_message, { ;
  //       '��ᬮ��/����� ���� �ࠢ�筨���';
  //     } )
  //   aadd(func_menu, {'o_sprav()'} )
  // case glob_task == X_SERVIS //
  //   aadd(cmain_menu, 1)
  //   aadd(main_menu,' ~��ࢨ�� ')
  //   aadd(main_message,'��ࢨ�� � ����ன��')
  //   //
  //   if glob_mo[_MO_KOD_TFOMS] == '395301' // ����設 ����
  //     aadd(first_menu, {'~�஢�ઠ 楫��⭮��', 0, ;
  //                       '��������� ~業 ���', 0, ;
  //                       '~������', ;
  //                       '~��ᯮ��', ;
  //                       '~���ਠ��'} )
  //     aadd(first_message, { ;
  //         '�஢�ઠ 楫��⭮�� ���� ������ �� 䠩�-�ࢥ�', ;
  //         '��������� 業 �� ��㣨 � ᮮ⢥��⢨� � �ࠢ�筨��� ��� �����', ;
  //         '������� ��ਠ��� ������ �� ��㣨� �ணࠬ�', ;
  //         '������� ��ਠ��� �ᯮ�� � ��㣨� �ணࠬ��/�࣠����樨', ;
  //         '��ࠢ�筨� �ਢ������� ��室㥬�� ���ਠ���';
  //       } )
  //     aadd(func_menu, {'prover_dbf(,.f.,(hb_user_curUser:IsAdmin()))', ;
  //                      'Change_Cena_OMS()', ;
  //                      'f_import()', ;
  //                      'f_export()', ;
  //                      'edit_ort()'} )

  //   else
  //     aadd(first_menu, {'~�஢�ઠ 楫��⭮��', 0, ;
  //                       '��������� ~業 ���', 0, ;
  //                       '~������', ;
  //                       '~��ᯮ��'} )
  //     aadd(first_message, { ;
  //         '�஢�ઠ 楫��⭮�� ���� ������ �� 䠩�-�ࢥ�', ;
  //         '��������� 業 �� ��㣨 � ᮮ⢥��⢨� � �ࠢ�筨��� ��� �����', ;
  //         '������� ��ਠ��� ������ �� ��㣨� �ணࠬ�', ;
  //         '������� ��ਠ��� �ᯮ�� � ��㣨� �ணࠬ��/�࣠����樨';
  //       } )
  //     aadd(func_menu, {'prover_dbf(,.f.,(hb_user_curUser:IsAdmin()))', ;
  //                      'Change_Cena_OMS()', ;
  //                      'f_import()', ;
  //                      'f_export()'} )
  //   endif
  //   //
  //   aadd(cmain_menu, 20)
  //   aadd(main_menu,' ~����ன�� ')
  //   aadd(main_message,'����ன��')
  //   aadd(first_menu, {'~��騥 ����ன��', 0, ;
  //                     '��ࠢ�筨�� ~�����', 0, ;
  //                     '~����祥 ����'} )
  //   aadd(first_message, { ;
  //       '��騥 ����ன�� ������ �����', ;
  //       '����ன�� ᮤ�ন���� �ࠢ�筨��� ����� (㬥��襭�� ������⢠ ��ப)', ;
  //       '����ன�� ࠡ�祣� ����';
  //     } )
  //   aadd(func_menu, {'nastr_all()', ;
  //                    'nastr_sprav_FFOMS()', ;
  //                    'nastr_rab_mesto()'} )
  //   aadd(cmain_menu, 50)
  //   aadd(main_menu,' ��稥 ~������ ')
  //   aadd(main_message,'����� �ᯮ��㥬� (���ॢ訥) ������')
  //   //
  //   if glob_mo[_MO_KOD_TFOMS] == '395301' // ����設 ����
  //     aadd(first_menu, { ;
  //                 '~���� ��樥���', ;
  //                 '���ଠ�� � ������⢥ 㤠���� ~�㡮�', ;
  //                 '~����୨����', ;
  //                 '���쬮 �792 �����~�', ;
  //                 '�����ਭ~� �� ����� ���.�����', ;
  //                 '����䮭��ࠬ�� �~15 �� ��', ;
  //                 '�������� ��� �-�� ~25 � ���.業�� 2', ;
  //                 '~���室 ���ਠ���'})
  //     aadd(first_message, { ;
  //                 '��ୠ� ॣ����樨 ����� ��樥�⮢', ;
  //                 '���ଠ�� � ������⢥ 㤠���� ����ﭭ�� �㡮� � 2005 �� 2015 ����', ;
  //                 '����⨪� �� ����୨��樨', ;
  //                 '�����⮢�� ��� ᮣ��᭮ �ਫ������ � ����� ������ �792 �� 16.06.2017�.', ;
  //                 '�����ਭ� �� ����� ����樭᪮� ����� ��� ������ ��ࠢ���࠭���� ��', ;
  //                 '���ଠ�� �� ��樮��୮�� ��祭�� ��� �������� ������ �� 2017 ���', ;
  //                 '�������� � 䠪��᪨� ������ �� �������� ����樭᪮� �����', ;
  //                 '��������� �� ��室� ���ਠ��� �� ��⥧�஢����'})
  //     aadd(func_menu, {'run_my_hrb("mo_hrb1","i_new_boln()")', ;
  //                      'run_my_hrb("mo_hrb1","i_kol_del_zub()")', ;
  //                      'modern_statist()', ;
  //                      'run_my_hrb("mo_hrb1","forma_792_MIAC()")', ;
  //                      'run_my_hrb("mo_hrb1","monitoring_vid_pom()")', ;
  //                      'run_my_hrb("mo_hrb1","phonegram_15_kz()")', ;
  //                      'run_my_hrb("mo_hrb1","b_25_perinat_2()")', ;
  //                      'Ort_OMS_material()'} )
  //   else
  //     aadd(first_menu, { ;
  //                 '~���� ��樥���', ;
  //                 '���ଠ�� � ������⢥ 㤠���� ~�㡮�', ;
  //                 '~����୨����', ;
  //                 '���쬮 �792 �����~�', ;
  //                 '�����ਭ~� �� ����� ���.�����', ;
  //                 '����䮭��ࠬ�� �~15 �� ��', ;
  //                 '�������� ��� �-�� ~25 � ���.業�� 2'})
  //     aadd(first_message, { ;
  //                 '��ୠ� ॣ����樨 ����� ��樥�⮢', ;
  //                 '���ଠ�� � ������⢥ 㤠���� ����ﭭ�� �㡮� � 2005 �� 2015 ����', ;
  //                 '����⨪� �� ����୨��樨', ;
  //                 '�����⮢�� ��� ᮣ��᭮ �ਫ������ � ����� ������ �792 �� 16.06.2017�.', ;
  //                 '�����ਭ� �� ����� ����樭᪮� ����� ��� ������ ��ࠢ���࠭���� ��', ;
  //                 '���ଠ�� �� ��樮��୮�� ��祭�� ��� �������� ������ �� 2017 ���', ;
  //                 '�������� � 䠪��᪨� ������ �� �������� ����樭᪮� �����'})
  //     aadd(func_menu, {'run_my_hrb("mo_hrb1","i_new_boln()")', ;
  //                      'run_my_hrb("mo_hrb1","i_kol_del_zub()")', ;
  //                      'modern_statist()', ;
  //                      'run_my_hrb("mo_hrb1","forma_792_MIAC()")', ;
  //                      'run_my_hrb("mo_hrb1","monitoring_vid_pom()")', ;
  //                      'run_my_hrb("mo_hrb1","phonegram_15_kz()")', ;
  //                      'run_my_hrb("mo_hrb1","b_25_perinat_2()")'} )
  //   endif
  // case glob_task == X_COPY //
  //   aadd(cmain_menu, 1)
  //   aadd(main_menu,' ~����ࢭ�� ����஢���� ')
  //   aadd(main_message,'����ࢭ�� ����஢���� ���� ������')
  //   aadd(first_menu, {;
  //       '����஢���� ~���� ������', ;
  //       '��ࠢ�� ���� ~������';
  //       })
  //   aadd(first_message, { ;
  //       '����ࢭ�� ����஢���� ���� ������', ;
  //       '����ࢭ�� ����஢���� ���� ������ � ��ࠢ�� ����� �㦡� �����প�';
  //     } )
  //   aadd(func_menu, {;
  //       'm_copy_DB(1)', ;
  //       'm_copy_DB(2)';
  //     })
  // case glob_task == X_INDEX //
  //   aadd(cmain_menu, 1)
  //   aadd(main_menu,' ~��२�����஢���� ')
  //   aadd(main_message,'��२�����஢���� ���� ������')
  //   aadd(first_menu, {'~��२�����஢����'} )
  //   aadd(first_message, { ;
  //       '��२�����஢���� ���� ������';
  //     } )
  //   aadd(func_menu, {'m_index_DB()'} )
  endcase
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
  // aadd(func_menu, {'view_file_in_Viewer(exe_dir + cslash + "README.RTF")', ;
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

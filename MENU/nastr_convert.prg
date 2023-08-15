#include 'set.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
// #include 'chip_mo.ch'

// 15.08.23 ����ன�� �������樨 䠩���
Function nastr_convert_files()
  Static group_ini := 'CONVERT_FILES'
  // Static mm_wdir := {{'� ����� ࠡ�祣� ��⠫��� "OwnChipArchiv"', 0}, ;
  //                    {'� ��㣮� ����', 1}}
  // Static mm_wokato := {{'�ᯮ�짮���� ���祭�� �� "���� ����஥�"', 0}, ;
  //                      {'᢮� ����ன�� �� ������ ࠡ�祬 ����', 1}}
  Local ar, sr, mm_tmp := {}
  local source_dir := '', destination_dir := ''

  // delete file tmp.dbf
  //
  ar := GetIniSect(get_app_ini(), group_ini)
  source_dir := a2default(ar, 'source_path', '')
  destination_dir := a2default(ar, 'destination_path', '')

  mm_tmp := { ;
    {group_ini, 'source_path',   source_dir}, ;
    {group_ini, 'destination_path',   destination_dir} ;
  }

  SetIniVar(get_app_ini(), mm_tmp)

  // aadd(mm_tmp, {'base_copy','N', 1, 0,NIL, ;
  //               {|x|menu_reader(x, mm_danet, A__MENUVERT)}, ;
  //               1, {|x|inieditspr(A__MENUVERT, mm_danet, x)}, ;
  //               '�믮����� ��⮬���᪮� १�ࢭ�� ����஢���� �� ��室� �� �ணࠬ��', , ;
  //               {|| hb_user_curUser:IsAdmin() }})
  // aadd(mm_tmp, {'wdir', 'N', 1, 0, NIL, ;
  //               {|x|menu_reader(x, mm_wdir, A__MENUVERT)}, ;
  //               0, {|x|inieditspr(A__MENUVERT, mm_wdir, x)}, ;
  //               '�> �㤠 �믮������ ����஢����', ;
  //               {|| iif(empty(m1wdir), (mpath_copy := m1path_copy := space(100), update_get('mpath_copy')), .t.) }, ;
  //               {|| hb_user_curUser:IsAdmin() .and. m1base_copy == 1 }})
  // aadd(mm_tmp, {'path_copy', 'C', 100, 0, NIL, ;
  //               {|x| menu_reader(x, {{|k, r, c| mng_dir(k, r, c, 'path_copy') }}, A__FUNCTION)}, ;
  //               ' ', {|x| x }, ;
  //               ' �> ��⠫�� ��� ����஢����',, ;
  //               {|| hb_user_curUser:IsAdmin() .and. m1base_copy == 1 .and. m1wdir == 1 }})
  // aadd(mm_tmp, {'kart_polis', 'N', 1, 0, NIL, ;
  //               {|x|menu_reader(x,mm_danet, A__MENUVERT)}, ;
  //               1, {|x|inieditspr(A__MENUVERT, mm_danet, x)}, ;
  //               '� ०��� ���������� � ����⥪� �ந������� ���� ��樥�� �� ������'})
  // aadd(mm_tmp, {'e_1', 'C', 1, 0, NIL, , '', , ;
  //               '����� ���� ���������� � ��७���� � ᫥���騩 ������塞� ��砩 �� �����', , ;
  //               {|| .f. }})
  // aadd(mm_tmp, {'oms_pole', 'N', 15, 0,NIL, ;
  //               {|x|menu_reader(x, mm_oms_pole, A__MENUBIT)}, ;
  //               0, {|x|inieditspr(A__MENUBIT, mm_oms_pole, x)}, ;
  //               '�/� ���:'})

  // init_base(cur_dir + 'tmp', , mm_tmp, 0)
  // use (cur_dir + 'tmp') new
  // append blank
  // tmp->base_copy := int(val(a2default(ar, 'base_copy', '1')))
  // tmp->path_copy := a2default(ar, 'path_copy', '')
  // tmp->wdir := iif(empty(tmp->path_copy), 0, 1)
  // tmp->kart_polis := int(val(a2default(ar, 'kart_polis', '1')))
  // close databases
  // if f_edit_spr(A__EDIT, mm_tmp, '����ன�� ࠡ�祣� ����', 'g_use(cur_dir + "tmp", , , .t.,.t.)', 0, 1) > 0
  //   use (cur_dir + 'tmp') new
  //   mm_tmp := { ;
  //              {group_ini, 'base_copy',   tmp->base_copy}, ;
  //              {group_ini, 'path_copy',   tmp->path_copy}, ;
  //              {group_ini, 'kart_polis',  tmp->kart_polis}, ;
  //              {group_ini, 'okato_umolch',tmp->_okato};
  //             }
  //   SetIniVar(get_app_ini(), mm_tmp)
  // endif
  // close databases
  return NIL

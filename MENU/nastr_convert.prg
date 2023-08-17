#include 'set.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'
#include 'tbox.ch'
// #include 'chip_mo.ch'

// 17.08.23 ����ன�� �������樨 䠩���
Function nastr_convert_files()
  Static group_ini := 'CONVERT_FILES'
  Local ar, mm_tmp := {}
  local source_dir := space(50), destination_dir := space(50)
  local name_db := space(20)
  local oBox := nil

  ar := GetIniSect(get_app_ini(), group_ini)
  source_dir := padr(a2default(ar, 'source_path', space(50)), 50)
  destination_dir := padr(a2default(ar, 'destination_path', space(50)), 50)
  name_db := padr(a2default(ar, 'name_sql_db', space(20)), 20)

  mm_tmp := { ;
    {group_ini, 'source_path',   source_dir}, ;
    {group_ini, 'destination_path',   destination_dir}, ;
    {group_ini, 'name_sql_db',   name_db} ;
  }

  oBox := TBox():New(10, 5, 20, 75, .t.)
  oBox:ChangeAttr := .t.
  oBox:CaptionColor := color8
  oBox:Caption := '����ன�� ��⠫���� ��� �������樨'
  oBox:Save := .t.

  oBox:View()

  SET CURSOR ON
  @ 2, 1 TBOX oBox say '��室�� ��⠫��:' get source_dir picture 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
  @ 3, 1 TBOX oBox say '��室��� ��⠫��:' get destination_dir picture 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
  @ 4, 1 TBOX oBox say '��� 䠩�� sql:' get name_db picture 'XXXXXXXXXXXXXXXXXXXX'
  read
  SET CURSOR OFF
  if lastkey() != 27
    mm_tmp := { ;
              {group_ini, 'source_path', source_dir}, ;
              {group_ini, 'destination_path', destination_dir}, ;
              {group_ini, 'name_sql_db', name_db} ;
              }
    SetIniVar(get_app_ini(), mm_tmp)
  endif

  return NIL

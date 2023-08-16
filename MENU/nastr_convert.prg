#include 'set.ch'
#include 'inkey.ch'
#include 'common.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'
#include 'tbox.ch'
// #include 'chip_mo.ch'

// 16.08.23 настройка конвертации файлов
Function nastr_convert_files()
  Static group_ini := 'CONVERT_FILES'
  Local ar, mm_tmp := {}
  local source_dir := space(50), destination_dir := space(50)
  local oBox := nil
  local a := 1, b := 2

  ar := GetIniSect(get_app_ini(), group_ini)
  source_dir := padr(a2default(ar, 'source_path', space(50)), 50)
  destination_dir := padr(a2default(ar, 'destination_path', space(50)), 50)

  mm_tmp := { ;
    {group_ini, 'source_path',   source_dir}, ;
    {group_ini, 'destination_path',   destination_dir} ;
  }

  oBox := TBox():New(10, 5, 20, 75, .t.)
  oBox:ChangeAttr := .t.
  oBox:CaptionColor := color8
  oBox:Caption := 'Настройка каталогов для конвертации'
  oBox:Save := .t.

  oBox:View()

  SET CURSOR ON
  @ 2, 1 TBOX oBox say 'Исходный каталог:' get source_dir picture 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
  @ 4, 1 TBOX oBox say 'Выходной каталог:' get destination_dir picture 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
  read
  SET CURSOR OFF
  if lastkey() != 27
    mm_tmp := { ;
               {group_ini, 'source_path', source_dir}, ;
               {group_ini, 'destination_path', destination_dir} ;
              }
    SetIniVar(get_app_ini(), mm_tmp)
  endif

  return NIL

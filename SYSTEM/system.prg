#include 'set.ch'
#include 'common.ch'
#include 'inkey.ch'
#include 'function.ch'
#include 'edit_spr.ch'
#include '.\check_pro.ch'

function __full_name()
  
  return 'ЧИП + служебные утилиты'

function cur_dir()
  static _cur_dir
  local cPrefix

  if isnil(_cur_dir)
#ifdef __PLATFORM__UNIX
      cPrefix := '/'
#else
      cPrefix := hb_curDrive() + ':\'
#endif
  _cur_dir := cPrefix + CurDir() + hb_ps()
  endif
  return _cur_dir

function dir_server()
   static _dir_server
   local mem_file := cur_dir() + 'server.mem'
  
   if isnil(_dir_server)
    if hb_FileExists(mem_file)
      ft_use(mem_file)
      _dir_server := alltrim(ft_readln())
      ft_use()
    else // иначе = текущий каталог
      hb_Alert('Отсутствует файл ' + mem_file)
      _dir_server := ''
    endif
   endif
   return _dir_server

function dir_exe()
  static _dir_exe
  
  if isnil(_dir_exe)
    _dir_exe := upper(beforatnum(hb_ps(), exename())) + hb_ps()
  endif
  return _dir_exe
  
function exe_dir()
  return dir_exe()

function cur_drv()
  return DISKNAME()

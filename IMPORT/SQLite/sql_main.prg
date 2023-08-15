#include 'inkey.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'tfile.ch'
#include '.\dict_error.ch'

// 15.08.23
function run_sqlimport()
  local source
  local destination
  local lExists
  local os_sep := hb_osPathSeparator()

  local db
  local lCreateIfNotExist := .t.
  local nameDB
  local lAll := .f.
  local lUpdate := .f.
  local file, name_table, cFunc, cMask := '*.xml'
  local fError, fOut
  local buf := SaveScreen()
  local ar
  local lOxx := .f.
  local lVxx := .f.
  local lQxx := .f.

  REQUEST HB_CODEPAGE_UTF8
  REQUEST HB_CODEPAGE_RU1251
  REQUEST HB_LANG_RU866

  // waitStatus()
  fError := TFileText():New(cur_dir() + 'error.log', , .t., , .t.)
  fOut := TFileText():New(cur_dir() + 'output.log', , .t., , .t.)

  // ar := GetIniSect(get_app_ini(), group_ini)
  // source := a2default(ar, 'source_path', '')
  // destination := a2default(ar, 'destination_path', '')

  source := 'd:\_mo\tf_usl\in\'
  destination := cur_dir()

  if !(lExists := hb_vfDirExists( source ))
    out_error(fError, DIR_IN_NOT_EXIST, source)
    return nil
  endi

  if !(lExists := hb_vfDirExists( destination ))
    out_error(fError, DIR_OUT_NOT_EXIST, destination)
    return nil
  endi

  fOut:add_string(hb_eol() + '����� ������⥪� SQLite3 - ' + sqlite3_libversion() + hb_eol())

  // if sqlite3_libversion_number() < 3005001
  //   return
  // endif

  // nameDB := destination + 'chip_mo.db'
  nameDB := destination + 'test.db'
  db := sqlite3_open(nameDB, lCreateIfNotExist)

  if ! Empty( db )
    #ifdef TRACE
         sqlite3_profile(db, .t.) // ����稬 ��䠩���
         sqlite3_trace(db, .t.)   // ����稬 ����஢騪
    #endif

    sqlite3_exec(db, 'PRAGMA auto_vacuum=0')
    sqlite3_exec(db, 'PRAGMA page_size=4096')

    make_other(db, source, fOut, fError)
    make_V0xx(db, source, fOut, fError)
    make_O0xx(db, source, fOut, fError)
    make_Q0xx(db, source, fOut, fError)

    make_F0xx(db, source, fOut, fError)
    make_N0xx(db, source, fOut, fError)
    make_mzdrav(db, source, fOut, fError)

    db := sqlite3_open_v2( nameDB, SQLITE_OPEN_READWRITE + SQLITE_OPEN_EXCLUSIVE )
    if ! Empty( db )
      if sqlite3_exec( db, 'VACUUM' ) == SQLITE_OK
        fOut:add_string('Pack - ok')
      else
        out_error(fError, PACK_ERROR, nameDB)
      endif
    endif
  endif

  RestScreen(buf)
  return nil
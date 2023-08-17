#include 'inkey.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'tfile.ch'
#include '.\dict_error.ch'

// 17.08.23
function run_sqlimport()
  local source
  local destination
  local os_sep := hb_osPathSeparator()

  local db
  local lCreateIfNotExist := .t.
  local nameDB
  local fError, fOut
  local buf := SaveScreen()
  local ar
  local group_ini := 'CONVERT_FILES'
  local name_sql

  REQUEST HB_CODEPAGE_UTF8
  REQUEST HB_CODEPAGE_RU1251
  REQUEST HB_LANG_RU866

  fError := TFileText():New(cur_dir() + 'error.log', , .t., , .t.)
  fOut := TFileText():New(cur_dir() + 'output.log', , .t., , .t.)

  ar := GetIniSect(get_app_ini(), group_ini)
  source := a2default(ar, 'source_path', '')
  destination := a2default(ar, 'destination_path', '')
  name_sql := a2default(ar, 'name_sql_db', 'chip_mo')

  // if ! hb_vfDirExists(source)
  //   hb_Alert('Каталог "' + source + '" для исходных файлов не существует!')
  //   return nil
  // endif

  // if ! hb_vfDirExists(destination)
  //   hb_Alert('Каталог "' + destination + '" для выходных файлов не существует!')
  //   return nil
  // endif

  // source := 'd:\_mo\tf_usl\in\'

  if !(hb_vfDirExists( source ))
    out_error(fError, DIR_IN_NOT_EXIST, source)
    return nil
  endi

  if !(hb_vfDirExists( destination ))
    out_error(fError, DIR_OUT_NOT_EXIST, destination)
    return nil
  endi

  fOut:add_string(hb_eol() + 'Версия библиотеки SQLite3 - ' + sqlite3_libversion() + hb_eol())

  // nameDB := destination + 'chip_mo.db'
  nameDB := destination + name_sql + '.db'  // 'test.db'
  db := sqlite3_open(nameDB, lCreateIfNotExist)

  if ! Empty( db )
    #ifdef TRACE
         sqlite3_profile(db, .t.) // включим профайлер
         sqlite3_trace(db, .t.)   // включим трассировщик
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
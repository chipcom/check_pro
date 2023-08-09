#include 'inkey.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'tfile.ch'
#include '.\dict_error.ch'

// 31.07.23
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
  local lOxx := .f.
  local lVxx := .f.
  local lQxx := .f.

  REQUEST HB_CODEPAGE_UTF8
  REQUEST HB_CODEPAGE_RU1251
  REQUEST HB_LANG_RU866
  // HB_CDPSELECT('UTF8')

  // @  8,  3 SAY 'Группа Oxx'
  // @  8, 15 GET lOxx CHECKBOX COLOR 'W/B+,W/B,W+/R,W/G+' MESSAGE 'Группа Oxx?'
  // @  9,  3 SAY 'Группа Vxx'
  // @  9, 15 GET lVxx CHECKBOX COLOR 'W/B+,W/B,W+/R,W/G+' MESSAGE 'Группа Vxx?'
  // @ 10,  3 SAY 'Группа Vxx'
  // @ 10, 15 GET lVxx CHECKBOX COLOR 'W/B+,W/B,W+/R,W/G+' MESSAGE 'Группа Vxx?'

  // READ  // MSG AT MaxRow(), 0, MaxCol() MSG COLOR 'W/B+'

  // if LastKey() == K_ESC
  //   return nil
  // endif

  waitStatus()
  fError := TFileText():New(cur_dir() + 'error.log', , .t., , .t.)
  fOut := TFileText():New(cur_dir() + 'output.log', , .t., , .t.)

  // source := upper(beforatnum(os_sep, exename())) + os_sep
  // destination := upper(beforatnum(os_sep, exename())) + os_sep
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

  fOut:add_string(hb_eol() + 'Версия библиотеки SQLite3 - ' + sqlite3_libversion() + hb_eol())

  // if sqlite3_libversion_number() < 3005001
  //   return
  // endif

  // nameDB := destination + 'chip_mo.db'
  nameDB := destination + 'test.db'
  db := sqlite3_open(nameDB, lCreateIfNotExist)

  if ! Empty( db )
    #ifdef TRACE
         sqlite3_profile(db, .t.) // включим профайлер
         sqlite3_trace(db, .t.)   // включим трассировщик
    #endif

    sqlite3_exec(db, 'PRAGMA auto_vacuum=0')
    sqlite3_exec(db, 'PRAGMA page_size=4096')

    // make_V0xx(db, source, fOut, fError)
    make_O0xx(db, source, fOut, fError)
    // make_Q0xx(db, source, fOut, fError)

    // make_F0xx(db, source, fOut, fError)
    // make_mzdrav(db, source, fOut, fError)
    // make_other(db, source, fOut, fError)

    db := sqlite3_open_v2( nameDB, SQLITE_OPEN_READWRITE + SQLITE_OPEN_EXCLUSIVE )
    if ! Empty( db )
      if sqlite3_exec( db, 'VACUUM' ) == SQLITE_OK
        // OutStd(hb_eol() + 'Pack - ok' + hb_eol())
      else
        out_error(fError, PACK_ERROR, nameDB)
      endif
    endif
  endif

  RestScreen(buf)
  return nil
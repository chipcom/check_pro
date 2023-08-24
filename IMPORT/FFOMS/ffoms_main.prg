#include 'inkey.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'tfile.ch'
#include '.\dict_error.ch'

/*
V024.xml     - для КСГ - Допкритерии
V018.xml     - классификатор видов высокотехнологичной медицинской помощи (HVid)
V019.xml     - классификатор методов высокотехнологичной медицинской помощи (HMet)
V025.xml     - Классификатор целей посещения (KPC)
V009.xml     - Классификатор результатов обращения за медицинской помощью (Rezult)
V010.xml     - Классификатор способов оплаты медицинской помощи (Sposob)
V012.xml     - Классификатор исходов заболевания (Ishod)
V016.xml     - Классификатор типов диспансеризации (DispT)
V017.xml     - Классификатор результатов диспансеризации (DispR)

V030.xml     - Схемы лечения заболевания COVID-19 (TreatReg)
V031.xml     - Группы препаратов для лечения заболевания COVID-19 (GroupDrugs)
V032.xml     - Сочетание схемы лечения и группы препаратов (CombTreat)
V033.xml     - Соответствие кода препарата схеме лечения (DgTreatReg)
V034.xml     - Единицы измерения (UnitMeas)
V035.xml     - Способы введения (MethIntro)
V036.xml     - Перечень услуг, требующих имплантацию медицинских изделий (ServImplDv)
V037.xml     - Перечень методов ВМП, требующих имплантацию медицинских изделий

OID 1.2.643.5.1.13.13.11.1006 - Степень тяжести состояния пациента
OID 1.2.643.5.1.13.13.11.1070 - Номенклатура медицинских услуг (используется в других справочниках)
OID 1.2.643.5.1.13.13.11.1079 - Виды медицинских изделий, имплантируемых в организм человека, и иных устройств для пациентов с ограниченными возможностями
OID 1.2.643.5.1.13.13.11.1358.xml - Единицы измерения
OID 1.2.643.5.1.13.13.11.1468.xml - Пути введения лекарственных препаратов
*/

// 18.08.23
function run_ffomsimport()
  local source
  local destination
  local os_sep := hb_osPathSeparator()

  local db
  local lCreateIfNotExist := .t.
  local nameDB
  local t1, t2
  local fError, nSizeError
  local fOut, nSizeOut
  local buf := SaveScreen()
  local ar
  local group_ini := 'CONVERT_FILES'
  local name_sql

  REQUEST HB_CODEPAGE_UTF8
  REQUEST HB_CODEPAGE_RU1251
  REQUEST HB_LANG_RU866

  fError := TFileText():New(cur_dir() + 'error.log', , .t., , .t.)
  fOut := TFileText():New(cur_dir() + 'output.log', , .t., , .t.)
  t1 := seconds()

  ar := GetIniSect(get_app_ini(), group_ini)
  source := a2default(ar, 'source_path', '')
  destination := a2default(ar, 'destination_path', '')
  name_sql := a2default(ar, 'name_sql_db', 'chip_mo')

  if right(source, 1) != os_sep
    source += os_sep
  endif

  if !(hb_vfDirExists( source ))
    out_error(fError, DIR_IN_NOT_EXIST, source)
    return nil
  endi

  if right(destination, 1) != os_sep
    destination += os_sep
  endif
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

    // make_other(db, source, fOut, fError)
    // make_V0xx(db, source, fOut, fError)
    make_O0xx(db, source, fOut, fError)
    // make_Q0xx(db, source, fOut, fError)

    // make_F0xx(db, source, fOut, fError)
    // make_N0xx(db, source, fOut, fError)
    // make_mzdrav(db, source, fOut, fError)

    db := sqlite3_open_v2( nameDB, SQLITE_OPEN_READWRITE + SQLITE_OPEN_EXCLUSIVE )
    if ! Empty( db )
      if sqlite3_exec( db, 'VACUUM' ) == SQLITE_OK
        fOut:add_string('Pack - ok')
      else
        out_error(fError, PACK_ERROR, nameDB)
      endif
    endif
  endif

  t2 := seconds() - t1

  if t2 > 0
    fOut:add_string('Время конвертации - ' + sectotime(t2) + hb_eol())
  endif

  nSizeError := fError:Size()
  nSizeOut := fOut:Size()
  fError := nil
  fOut := nil

  if nSizeError > 0
    viewtext(cur_dir() + 'error.log', , , , .t., , , 2)
  endif
  if nSizeOut > 0
    viewtext(cur_dir() + 'output.log', , , , .t., , , 2)
  endif
  
  RestScreen(buf)
  return nil
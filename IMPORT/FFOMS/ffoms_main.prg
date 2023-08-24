#include 'inkey.ch'
#include 'directry.ch'
#include 'function.ch'
#include 'tfile.ch'
#include '.\dict_error.ch'

/*
V024.xml     - ��� ��� - ������ਨ
V018.xml     - �����䨪��� ����� ��᮪��孮����筮� ����樭᪮� ����� (HVid)
V019.xml     - �����䨪��� ��⮤�� ��᮪��孮����筮� ����樭᪮� ����� (HMet)
V025.xml     - �����䨪��� 楫�� ���饭�� (KPC)
V009.xml     - �����䨪��� १���⮢ ���饭�� �� ����樭᪮� ������� (Rezult)
V010.xml     - �����䨪��� ᯮᮡ�� ������ ����樭᪮� ����� (Sposob)
V012.xml     - �����䨪��� ��室�� ����������� (Ishod)
V016.xml     - �����䨪��� ⨯�� ��ᯠ��ਧ�樨 (DispT)
V017.xml     - �����䨪��� १���⮢ ��ᯠ��ਧ�樨 (DispR)

V030.xml     - �奬� ��祭�� ����������� COVID-19 (TreatReg)
V031.xml     - ��㯯� �९��⮢ ��� ��祭�� ����������� COVID-19 (GroupDrugs)
V032.xml     - ���⠭�� �奬� ��祭�� � ��㯯� �९��⮢ (CombTreat)
V033.xml     - ���⢥��⢨� ���� �९��� �奬� ��祭�� (DgTreatReg)
V034.xml     - ������� ����७�� (UnitMeas)
V035.xml     - ���ᮡ� �������� (MethIntro)
V036.xml     - ���祭� ���, �ॡ���� ��������� ����樭᪨� ������� (ServImplDv)
V037.xml     - ���祭� ��⮤�� ���, �ॡ���� ��������� ����樭᪨� �������

OID 1.2.643.5.1.13.13.11.1006 - �⥯��� �殮�� ���ﭨ� ��樥��
OID 1.2.643.5.1.13.13.11.1070 - ����������� ����樭᪨� ��� (�ᯮ������ � ��㣨� �ࠢ�筨���)
OID 1.2.643.5.1.13.13.11.1079 - ���� ����樭᪨� �������, ��������㥬�� � �࣠���� 祫�����, � ���� ���ன�� ��� ��樥�⮢ � ��࠭�祭�묨 ����������ﬨ
OID 1.2.643.5.1.13.13.11.1358.xml - ������� ����७��
OID 1.2.643.5.1.13.13.11.1468.xml - ��� �������� ������⢥���� �९��⮢
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

  fOut:add_string(hb_eol() + '����� ������⥪� SQLite3 - ' + sqlite3_libversion() + hb_eol())

  // nameDB := destination + 'chip_mo.db'
  nameDB := destination + name_sql + '.db'  // 'test.db'
  db := sqlite3_open(nameDB, lCreateIfNotExist)

  if ! Empty( db )
    #ifdef TRACE
         sqlite3_profile(db, .t.) // ����稬 ��䠩���
         sqlite3_trace(db, .t.)   // ����稬 ����஢騪
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
    fOut:add_string('�६� �������樨 - ' + sectotime(t2) + hb_eol())
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
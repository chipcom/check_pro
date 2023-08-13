#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'
#define COMMIT_COUNT  500

// 13.08.23
function make_other(db, source, fOut, fError)

  make_t005(db, source, fOut, fError)
  make_t007(db, source, fOut, fError)
  make_ISDErr(db, source, fOut, fError)
  dlo_lgota(db, source, fOut, fError)
  err_csv_prik(db, source, fOut, fError)
  rekv_smo(db, source, fOut, fError)
  return nil

// 13.08.23
function make_t007(db, source, fOut, fError)
  // PROFIL_K,  N,  2
  // PK_V020,   N,  2
  // PROFIL,    N,  2
  // NAME,      C,  255

  local cmdText
  local j
  local nfile, nameRef
  local profil_k, pk_v020, profil, name
  local dbSource := 't007'
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE t007(profil_k INTEGER, pk_v020 INTEGER, profil INTEGER, name TEXT)'

  nameRef := 't007.dbf'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - ��ࠢ�筨� T007')
  endif
  
  fOut:add_string(hb_eol() + '�����䨪��� T007')

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS t007') == SQLITE_OK
    fOut:add_string('DROP TABLE t007 - Ok')
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE t007 - Ok' )
  else
    fOut:add_string('CREATE TABLE t007 - False' )
    return nil
  endif

  dbUseArea(.t., , nfile, dbSource, .t., .f.)
  j := 0
  do while !(dbSource)->(EOF())
    j++
    profil_k := (dbSource)->PROFIL_K
    pk_v020 := (dbSource)->PK_V020
    profil := (dbSource)->PROFIL
    name := (dbSource)->NAME

    count++
    cmdTextInsert += 'INSERT INTO t007(profil_k, pk_v020, profil, name) VALUES(' ;
        + "" + alltrim(str(profil_k)) + "," ;
        + "" + alltrim(str(pk_v020)) + "," ;
        + "" + alltrim(str(profil)) + "," ;
        + "'" + name + "');"
    if count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
      count := 0
      cmdTextInsert := textBeginTrans
    endif

    (dbSource)->(dbSkip())
  end do
  (dbSource)->(dbCloseArea())
  if count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec(db, cmdTextInsert)
  endif
  fOut:add_string('��ࠡ�⠭� ' + str(j) + ' 㧫��.' + hb_eol() )
  return nil

// 13.08.23
function make_ISDErr(db, source, fOut, fError)
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local code, name, name_f
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  // CODE, �����᫥���(3),	��� �訡��
  // NAME, �����(250),	������������ �訡��
  // NAME_F, �����(250), �������⥫쭠� ���ଠ�� �� �訡��
  // DATEBEG, �����(10),	��� ��砫� ����⢨� �����
  // DATEEND, �����(10),	��� ����砭�� ����⢨� �����
  // cmdText := 'CREATE TABLE isderr( code INTEGER, name TEXT(250), name_f TEXT(250))'
  cmdText := 'CREATE TABLE isderr( code INTEGER, name TEXT(250))'

  nameRef := 'ISDErr.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - ��ࠢ�筨� �訡�� ������ (�012)')
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE IF EXISTS isderr') == SQLITE_OK
    fOut:add_string('DROP TABLE isderr - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE isderr - Ok' )
  else
    fOut:add_string('CREATE TABLE isderr - False' )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)

  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('��ࠡ�⪠ - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
        code := read_xml_stroke_1251_to_utf8(oXmlNode, 'CODE')
        name := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME')

        count++
        cmdTextInsert += 'INSERT INTO isderr(code, name) VALUES(' ;
            + "" + code + "," ;
            + "'" + name + "');"
        if count == COMMIT_COUNT
          cmdTextInsert += textCommitTrans
          sqlite3_exec(db, cmdTextInsert)
          count := 0
          cmdTextInsert := textBeginTrans
        endif
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 13.08.23
function dlo_lgota(db, source, fOut, fError)
  // �����䨪��� ����� �죮� �� ���
  //  1 - NAME(C)  2 - KOD(C)

  local cmdText
  local k
  local mKod, mName
  local mArr := {}
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  aadd(mArr, {'000 --- ��� �죮�� ---', '   '})
  aadd(mArr, {'010 �������� �����', '010'})
  aadd(mArr, {'011 ���⭨�� ������� ����⢥���� �����, �⠢訥 ����������', '011'})
  aadd(mArr, {'012 �������㦠騥 �࣠��� ����७��� ���, ���㤠��⢥���� ��⨢�����୮� �㦡�, ��०����� � �࣠��� 㣮�����-�ᯮ���⥫쭮� ��⥬�, �⠢�� ���������� �᫥��⢨� ࠭����, ����㧨� ��� 㢥���, ����祭��� �� �ᯮ������ ��易����⥩ ������� �㦡�', '012'})
  aadd(mArr, {'020 ���⭨�� ������� ����⢥���� �����', '020'})
  aadd(mArr, {'030 ���࠭� ������ ����⢨�', '030'})
  aadd(mArr, {'040 �������㦠騥, ��室��訥 ������� �㦡� � ����᪨� �����, �� �室���� � ��⠢ �������饩 �ନ�, � ��ਮ� � 22 ��� 1941 ���� �� 3 ᥭ���� 1945 ���� �� ����� ��� ����楢, �������㦠騥, ���ࠦ����� �थ���� ��� �����ﬨ ����', '040'})
  aadd(mArr, {'050 ���, ���ࠦ����� ������ "��⥫� ���������� ������ࠤ�"', '050'})
  aadd(mArr, {'060 ����� ᥬ�� ������� (㬥���) ��������� �����, ���⭨��� ������� ����⢥���� ����� � ���࠭�� ������ ����⢨�', '060'})
  aadd(mArr, {'061 ����� ᥬ�� ������� � ������� ����⢥���� ����� ��� �� �᫠ ��筮�� ��⠢� ��㯯 ᠬ������ ��ꥪ⮢�� � ���਩��� ������ ���⭮� ��⨢������譮� ���஭�, � ⠪�� 童�� ᥬ�� ������� ࠡ�⭨��� ��ᯨ⠫�� � ���쭨� ��த� ������ࠤ�', '061'})
  aadd(mArr, {'062 ����� ᥬ�� �������㦠�� �࣠��� ����७��� ���, ���㤠��⢥���� ��⨢�����୮� �㦡�, ��०����� � �࣠��� 㣮�����-�ᯮ���⥫쭮� ��⥬� � �࣠��� ���㤠��⢥���� ������᭮��, ������� �� �ᯮ������ ��易����⥩ ������� �㦡�', '062'})
  aadd(mArr, {'063 ����� ᥬ�� �������㦠��, ������� � �����, �ਧ������ � ��⠭�������� ���浪� �ய��訬� ��� ���� � ࠩ���� ������ ����⢨�', '063'})
  aadd(mArr, {'081 �������� I �⥯���', '081'})
  aadd(mArr, {'082 �������� II �⥯���', '082'})
  aadd(mArr, {'083 �������� III �⥯���', '083'})
  aadd(mArr, {'084 ���-��������', '084'})
  aadd(mArr, {'085 ��������, �� ����騥 �⥯��� ��࠭�祭�� ᯮᮡ���� � ��㤮��� ���⥫쭮��', '085'})
  aadd(mArr, {'091 �ࠦ����, ����稢訥 ��� ��७��訥 ��祢�� ������� � ��㣨� �����������, �易��� � ࠤ��樮��� �������⢨�� �᫥��⢨� �୮���᪮� �������� ��� � ࠡ�⠬� �� �������樨 ��᫥��⢨� �������� �� ��୮���᪮� ���', '091'})
  aadd(mArr, {'092 �������� �᫥��⢨� �୮���᪮� ��������', '092'})
  aadd(mArr, {'093 �ࠦ����, �ਭ����訥 � 1986-1987 ����� ���⨥ � ࠡ��� �� �������樨 ��᫥��⢨� �୮���᪮� ��������', '093'})
  aadd(mArr, {'094 �ࠦ����, �ਭ����訥 ���⨥ � 1988-90��. ���⨥ � ࠡ��� �� �������樨 ��᫥��⢨� �୮���᪮� ��������', '094'})
  aadd(mArr, {'095 �ࠦ����, ����ﭭ� �஦����騥 (ࠡ���騥) �� ����ਨ ���� �஦������ � �ࠢ�� �� ��ᥫ����', '095'})
  aadd(mArr, {'096 �ࠦ����, ����ﭭ� �஦����騥 (ࠡ���騥) �� ����ਨ ���� �஦������ � �죮�� �樠�쭮-������᪨� ����ᮬ', '096'})
  aadd(mArr, {'097 �ࠦ����, ����ﭭ� �஦����騥 (ࠡ���騥) � ���� ��ᥫ���� �� �� ���ᥫ���� � ��㣨� ࠩ���', '097'})
  aadd(mArr, {'098 �ࠦ����, ���஢���� (� ⮬ �᫥ ��堢訥 ���஢��쭮) � 1986 ���� �� ���� ���㦤����', '098'})
  aadd(mArr, {'099 ��� � �����⪨ � ������ �� 18 ���, �஦����騥 � ���� ��ᥫ���� � ���� �஦������ � �ࠢ�� �� ��ᥫ����, ���஢���� � ���ᥫ���� �� ��� ���㦤����, ��ᥫ����, �஦������ � �ࠢ�� �� ��ᥫ����', '099'})
  aadd(mArr, {'100 ��� � �����⪨ � ������ �� 18 ���, ����ﭭ� �஦����騥 � ���� � �죮�� �樠�쭮-������᪨� ����ᮬ', '100'})
  aadd(mArr, {'101 ��� � �����⪨, ��ࠤ��騥 ������ﬨ �᫥��⢨� �୮���᪮� ��������, �⠢訥 ����������', '101'})
  aadd(mArr, {'102 ��� � �����⪨, ��ࠤ��騥 ������ﬨ �᫥��⢨� �୮���᪮� ��������', '102'})
  aadd(mArr, {'111 �ࠦ����, ����稢訥 �㬬���� (������⥫���) ��䥪⨢��� ���� ����祭��, �ॢ������ 25 ᇢ (���)', '111'})
  aadd(mArr, {'112 �ࠦ����, ����稢訥 �㬬���� (������⥫���) ��䥪⨢��� ���� ����祭�� ����� 5 ᇢ (���), �� �� �ॢ������ 25 ᇢ (���)', '112'})
  aadd(mArr, {'113 ��� � ������ �� 18 ��� ��ࢮ�� � ��ண� ��������� �ࠦ���, ����稢訥 �㬬���� (������⥫���) ��䥪⨢��� ���� ����祭�� ����� 5 ᇢ (���), ��ࠤ���� ����������ﬨ �᫥��⢨� ࠤ��樮����� �������⢨� �� ������ �� த�⥫��', '113'})
  aadd(mArr, {'120 ���, ࠡ�⠢訥 � ��ਮ� ������� ����⢥���� ����� �� ��ꥪ�� ��⨢������譮� ���஭�, �� ��ந⥫��⢥ ���஭�⥫��� ᮮ�㦥���, ������-���᪨� ���, ��த஬�� � ��㣨� ������� ��ꥪ⮢', '120'})
  aadd(mArr, {'121 �ࠦ����, ����稢訥 ��祢�� �������, ���᫮������� �������⢨�� ࠤ��樨 �᫥��⢨� ���ਨ � 1957 ���� �� �ந�����⢥���� ��ꥤ������ "���" � ��ᮢ ࠤ����⨢��� ��室�� � ४� ���', '121'})
  aadd(mArr, {'122 �ࠦ����, �⠢訥 ���������� � १���� �������⢨� ࠤ��樨 �᫥��⢨� ���ਨ � 1957 ���� �� �ந�����⢥���� ��ꥤ������ "���" � ��ᮢ ࠤ����⨢��� ��室�� � ४� ���', '122'})
  aadd(mArr, {'123 �ࠦ����, �ਭ����訥 � 1957-58��. ���⨥ � ࠡ��� �� �������樨 ��᫥��⢨� ���ਨ � 1957 ���� �� �ந�����⢥���� ��ꥤ������ "���", � ⠪�� �ࠦ����, ������ �� ࠡ��� �� �஢������ ��ய��⨩ ����� ४� ��� � 1949-56��.', '123'})
  aadd(mArr, {'124 �ࠦ����, �ਭ����訥 � 1959-61��. ���⨥ � ࠡ��� �� �������樨 ��᫥��⢨� ���ਨ � 1957 ���� �� �ந�����⢥���� ��ꥤ������ "���", � ⠪�� �ࠦ����, ������ �� ࠡ��� �� �஢������ ��ய��⨩ ����� ४� ��� � 1957-62��.', '124'})
  aadd(mArr, {'125 �ࠦ����, �஦����騥 � ��ᥫ����� �㭪��, ���������� ࠤ����⨢���� ����吝���� �᫥��⢨� ���ਨ � 1957 ���� �� �ந�����⢥���� ��ꥤ������ "���" � ��ᮢ ࠤ����⨢��� ��室�� � ४� ���', '125'})
  aadd(mArr, {'128 �ࠦ����, ���஢���� �� ��ᥫ����� �㭪⮢, ���������� ࠤ����⨢���� ����吝���� �᫥��⢨� ���ਨ � 1957 ���� �� �ந�����⢥���� ��ꥤ������ "���" � ��ᮢ ࠤ����⨢��� ��室�� � ४� ���', '128'})
  aadd(mArr, {'129 ��� ��ࢮ�� � ��ண� ��������� �ࠦ���, 㪠������ � ���� 1 ����ࠫ쭮�� ������ �� 26.11.98 � 175-��, ��ࠤ��騥 ����������ﬨ �᫥��⢨� �������⢨� ࠤ��樨 �� �� த�⥫��', '129'})
  aadd(mArr, {'131 �ࠦ���� �� ���ࠧ������� �ᮡ��� �᪠, �� ����騥 �����������', '131'})
  aadd(mArr, {'132 �ࠦ���� �� ���ࠧ������� �ᮡ��� �᪠, ����騥 ������������', '132'})
  aadd(mArr, {'140 ��訥 ��ᮢ��襭����⭨� 㧭��� ���櫠��३, �ਧ����� ���������� �᫥��⢨� ��饣� �����������, ��㤮���� 㢥��� � ��㣨� ��稭 (�� �᪫�祭��� ���, ������������ ������ ����㯨�� �᫥��⢨� �� ��⨢��ࠢ��� ����⢨�)', '140'})
  aadd(mArr, {'141 ����稥 � �㦠騥, � ⠪�� �������㦠�� �࣠��� ����७��� ���, ���㤠��⢥���� ��⨢�����୮� �㦡�, ����稢訥 ����ᨮ����� �����������, �易��� � ��祢� �������⢨�� �� ࠡ��� � ���� ���㦤����', '141'})
  aadd(mArr, {'142 ����稥 � �㦠騥, � ⠪�� �������㦠騥 �࣠��� ����७��� ���, ���㤠��⢥���� ��⨢�����୮� �㦡�, ����稢�� ����ᨮ����� �����������, �易��� � ��祢� �������⢨�� �� ࠡ��� � ���� ���㦤����, �⠢訥 ����������', '142'})
  aadd(mArr, {'150 ��訥 ��ᮢ��襭����⭨� 㧭��� ���櫠��३', '150'})

  cmdText := 'CREATE TABLE dlo_lgota(kod TEXT(3), name TEXT)'

  fOut:add_string(hb_eol() + '�����䨪��� ����� �죮� �� ���')

  stat_msg('�����䨪��� ����� �죮� �� ���')  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS dlo_lgota') == SQLITE_OK
    fOut:add_string('DROP TABLE dlo_lgota - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE dlo_lgota - Ok' )
  else
    fOut:add_string('CREATE TABLE dlo_lgota - False' )
    return nil
  endif

  for k := 1 to len(mArr)
    mKod := mArr[k, 2]
    mName := mArr[k, 1]
    count++
    cmdTextInsert += 'INSERT INTO dlo_lgota(kod, name) VALUES(' ;
        + "'" + mKod + "'," ;
        + "'" + mName + "');"
    if count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
      count := 0
      cmdTextInsert := textBeginTrans
    endif
  next
  if count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec(db, cmdTextInsert)
  endif
  fOut:add_string('��ࠡ�⠭� ' + str(len(mArr)) + ' 㧫��.' + hb_eol() )

  return nil

// 13.08.23
function err_csv_prik(db, source, fOut, fError)
  // �����䨪��� ����� �죮� �� ���
  //  1 - NAME(C)  2 - KOD(C)

  local cmdText
  local k
  local mKod, mName
  local arr := {}
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  aadd(arr, {"����ୠ� �������",1})
  aadd(arr, {"��������� ����� ����� ����� ��� ����� ��� ������� ��ࠧ�",2})
  aadd(arr, {'����� �६������ ����� ����� �� ࠢ�� 9',3})
  aadd(arr, {'����� ������ ����� ����� �� ࠢ�� 16 (����ୠ� ����஫쭠� �㬬�)',4})
  aadd(arr, {"�������⨬� ����� ��� ��⠭�� ������ � 䠬����",5})
  aadd(arr, {"�������⨬� ����� ��� ��⠭�� ������ � �����",6})
  aadd(arr, {"�������⨬� ����� ��� ��⠭�� ������ � ����⢥",7})
  aadd(arr, {"�� 㪠���� ��� ஦�����",10})
  aadd(arr, {"�訡�� � ��� ஦����� (㪠���� ��ॠ�쭠� ���)",11})
  aadd(arr, {"������ �����४�� �����",12})
  aadd(arr, {"� ��ப� ������� �������⨬� ᨬ����",13})
  aadd(arr, {"������ ���浪��� ����� 䠩��",19})
  aadd(arr, {"��� ���㠫���樨 ����� ⥪�饩 ����",20})
  aadd(arr, {"�訡�� � ���祭�� �����",21})
  aadd(arr, {"�訡�� � ����஫쭮� �᫥ �����",22})
  aadd(arr, {"������ ��� ����ਨ",24})
  aadd(arr, {"��������� ��� � ����� ��� ����� ��� ��ண� ��ࠧ� ��� ����� ��� �६������ ᢨ��⥫��⢠",25})
  aadd(arr, {"�訡�� � ��������� ��⠤����� 䠩��",38})
  aadd(arr, {"�訡�� � �ଠ� ���� �ਪ९�����",46})
  aadd(arr, {"�� 㪠���� ��� ���㠫���樨",86})
  aadd(arr, {"��� �ਪ९����� ����� ���� ���㠫���樨",87})
  aadd(arr, {"��ଠ� ������� ����� ����� ����७",102})
  aadd(arr, {"����ୠ� ����� �ଠ�",183})
  aadd(arr, {"�� 㪠��� ����� ����樭᪮�� ࠡ�⭨��",239})
  aadd(arr, {"�� 㪠��� ��� ᯮᮡ� �ਪ९����� � ��",242})
  aadd(arr, {"�������⨬� ��� ᯮᮡ� �ਪ९����� � ��",243})
  aadd(arr, {"��� �ਪ९����� �� ���������",245})
  aadd(arr, {"�訡�� � ��� �ਪ९�����",246})
  aadd(arr, {"�����஢� ����� �� �� 㪠���",264})
  aadd(arr, {"�����஢� ����� �� �� ������",265})
  aadd(arr, {"������ �ଠ� ॥��஢��� ����� ��",300})
  aadd(arr, {"�� �।��⠢����� ����� �����客����� ��� �� ������� � ॣ���� �����客����� ���",404})
  aadd(arr, {"����� ����� ����� �� ������ � ॣ���� �����客����� ���",500})
  aadd(arr, {"���������� �������஢��� �����客����� ��� � ������ ॣ���� �����客����� ���",522})
  aadd(arr, {"����� ����� ����� �� ᮮ⢥����� 㪠������� ���㬥���, ���⢥ত��饬� 䠪� ���客����",525})
  aadd(arr, {"�� �� ࠡ�⠥� �� ����ਨ",541})
  aadd(arr, {'�����客����� ��� �� �ਪ९���� � �� (��� ����樨 "�" �� ������� ��������� ������ � �ਪ९�����)',542})
  aadd(arr, {"���ࠡ�⭨� �� ������ � ����ࠫ쭮� ॥��� ���ࠡ�⭨���",543})
  aadd(arr, {"���ࠡ�⭨� �� ࠡ�⠥� � 㪠������ ��",544})
  aadd(arr, {"������ ��ன ���ࠡ�⭨� � ⮩ �� ����������",545})
  aadd(arr, {"������ ��⨩ ���ࠡ�⭨� (����� ���� �ਪ९�����)",546})
  aadd(arr, {"��� �ਪ९����� � ���ࠡ�⭨�� ����� ���� �ਪ९����� � �� ��� �।��饬� ���ࠡ�⭨��",547})
  aadd(arr, {"� ॥��� ���������� ᢥ����� �� �ਪ९����� 㪠������� ��� � ��",548})
  aadd(arr, {"��� ���, �� �������஢������ � ॥��� �����客�����, �� 㪠��� ���",555})
  aadd(arr, {"��� ������, 㪠������ � 䠩��, ����� ����饩�� � ��� ���� �ਪ९�����",600})
  aadd(arr, {"�ਪ९����� � �祭�� ������ ���� � �⮩ �� �� (�����४⭮� �ਪ९�����)",701})
  aadd(arr, {"�ਪ९����� � �祭�� ������ ���� � ��㣮� �� (�����४⭮� �ਪ९�����)",702})
  aadd(arr, {"�� 㪠������ ���� �ਪ९����� �� �� ����� �������饣� ���客���� � ������ࠤ᪮� ������",703})
  aadd(arr, {"��� �ਪ९����� ����� ���� ᬥ��",704})
  aadd(arr, {"������ ᯮᮡ �ਪ९�����",705})
  aadd(arr, {"�����客���� 㬥�",706})
  aadd(arr, {"������ ��� ᯮᮡ� �ਪ९����� ��� �ਪ९����� ��� ��������� ���� ��⥫��⢠ � ����� ����",707})
  aadd(arr, {'����ୠ� ��� �ਪ९����� ��� ����୮ 㪠���� ��⥣��� ���',708})
  aadd(arr, {"�� 㦥 �ਪ९���� � ��襩 �࣠����樨 �� ����� �� ���",709})
  aadd(arr, {"�訡�� � ��� ��९�����",746})
  aadd(arr, {"��ࠡ�⪠ ������ �� �� �믮��﫠�� (���ࠢ��� ����୮)",801})
  aadd(arr, {"�� �� ������� � �� ��� (�஢���� ����� � ���ࠢ��� ����୮)",802})
  aadd(arr, {"����稥 �訡�� ���, �ਪ������ ��ࠡ�⪨ (�஢���� ����� � ���ࠢ��� ����୮)",803})
  aadd(arr, {"� �ணࠬ�� ��ࠡ�⪨ �������� �᪫��⥫쭠� �����",99})

  cmdText := 'CREATE TABLE err_csv_prik(kod INTEGER, name TEXT)'

  fOut:add_string(hb_eol() + '���� �訡�� �ਪ९����� ��ᥫ����')

  stat_msg('���� �訡�� �ਪ९����� ��ᥫ����')  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS err_csv_prik') == SQLITE_OK
    fOut:add_string('DROP TABLE err_csv_prik - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE err_csv_prik - Ok' )
  else
    fOut:add_string('CREATE TABLE err_csv_prik - False' )
    return nil
  endif

  for k := 1 to len(arr)
    mKod := arr[k, 2]
    mName := arr[k, 1]
    count++
    cmdTextInsert += 'INSERT INTO err_csv_prik(kod, name) VALUES(' ;
        + "" + alltrim(str(mKod)) + "," ;
        + "'" + mName + "');"
    if count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
      count := 0
      cmdTextInsert := textBeginTrans
    endif
  next
  if count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec(db, cmdTextInsert)
  endif
  fOut:add_string('��ࠡ�⠭� ' + str(len(arr)) + ' 㧫��.' + hb_eol() )

  return nil

// 13.08.23
function rekv_smo(db, source, fOut, fError)
  local cmdText
  local k
  local arr
  local  mKod, mName, mINN, mKPP, mOGRN, mAddres
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  // 1-���,2-���,3-���,4-���,5-����,6-����,7-����,8-�.���,9-���
  arr := { ;
    {'34001', ;
     '������ ��������� ������������ �������� "������� ����������� �����������" � ������ ����������', ;
      '7709028619', ;
      '344343001', ;
      '1028601441274', ;
      '400075 ������ࠤ᪠� ���., �.������ࠤ, �.�����᪠�, �.122', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34002', ;
      '������������� ������ ������������ �������� "��������� �������� "����� - ���"', ;
      '7728170427', ;
      '344343001', ;
      '1027739008440', ;
      '400105 ������ࠤ᪠� ���., �.������ࠤ, �.�⥬����, �.5', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34003', ;
      '����������� �������� ��� ����������� �����������', ;
      '7704103750', ;
      '774401001', ;
      '1027739815245', ;
      '400005 ������ࠤ᪠� ���., �.������ࠤ, �.���, �.19', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34004', ;
      '������������� ������ �������� � ������������ ���������������� "��������� �������� ��� ����������"', ;
      '7730519137', ;
      '775001001', ;
      '1057746135325', ;
      '400131 ������ࠤ᪠� ���., �.������ࠤ, �.����㭨���᪠�, �.32', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34006', ;
      '������ �������� � ������������ ���������������� "����������� ��������� �������� "��������" � �.����������', ;
      '6161056686', ;
      '344445001', ;
      '1106193000022', ;
      '400074 ������ࠤ᪠� ���., �.������ࠤ, �.���஢᪠�, �.24', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34007', ;
      '������ �������� � ������������ ���������������� "������� ����������� �����������" � ������������� �������', ;
      '7813171100', ;
      '344303001', ;
      '1027806865481', ;
      '400074 ������ࠤ᪠� ���., �.������ࠤ, �.�����-������᪠�, �.30�', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34   ', ;
      '��������������� ���������� "��������������� ���� ������������� ������������ ����������� ������������� �������"', ;
      '          ', ;
      '         ', ;
      '1023403856123', ;
      '400005 �.������ࠤ, ��ᯥ�� ������, 56�', ;
      '', ;
      '', ;
      '' ;
    } ;
  }

  cmdText := 'CREATE TABLE rekv_smo(kod TEXT(5), name TEXT, inn TEXT(10), kpp TEXT(9), ogrn TEXT(13), addres TEXT)'

  fOut:add_string(hb_eol() + '���客� ��������')

  stat_msg('���客� ��������')  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS rekv_smo') == SQLITE_OK
    fOut:add_string('DROP TABLE rekv_smo - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE rekv_smo - Ok' )
  else
    fOut:add_string('CREATE TABLE rekv_smo - False' )
    return nil
  endif

  for k := 1 to len(arr)
    mKod := arr[k, 1]
    mName := arr[k, 2]
    mINN := arr[k, 3]
    mKPP := arr[k, 4]
    mOGRN := arr[k, 5]
    mAddres := arr[k, 6]
    count++
    cmdTextInsert += 'INSERT INTO rekv_smo(kod, name, inn, kpp, ogrn, addres) VALUES(' ;
        + "'" + mKod + "'," ;
        + "'" + mName + "'," ;
        + "'" + mINN + "'," ;
        + "'" + mKPP + "'," ;
        + "'" + mOGRN + "'," ;
        + "'" + mAddres + "');"
    if count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
      count := 0
      cmdTextInsert := textBeginTrans
    endif
  next
  if count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec(db, cmdTextInsert)
  endif
  fOut:add_string('��ࠡ�⠭� ' + str(len(arr)) + ' 㧫��.' + hb_eol() )

  return nil

// 13.08.23
function make_t005(db, source, fOut, fError)
  // CODE,     "N",    4,      0
  // ERROR,  "C",  91,      0
  // OPIS, "C",  251,      0
  // DATEBEG, "D",    8,      0
  // DATEEND, "D",    8,      0

  local cmdText
  local j
  local nfile, nameRef
  local mCode, mError, mOpis, d1, d2, d1_1, d2_1
  local dbSource := 't005'
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE t005(code INTEGER, error TEXT, opis TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 't005.dbf'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - ��ࠢ�筨� �訡��')
  endif

  fOut:add_string(hb_eol() + '�����䨪��� ����� �訡�� T005')

  stat_msg('�����䨪��� ����� �訡�� T005')  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS t005') == SQLITE_OK
    fOut:add_string('DROP TABLE t005 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE t005 - Ok' )
  else
    fOut:add_string('CREATE TABLE t005 - False' )
    return nil
  endif

  dbUseArea(.t., , nfile, dbSource, .t., .f.)
  j := 0
  do while !(dbSource)->(EOF())
    j++
    mCode := (dbSource)->CODE
    mError := (dbSource)->ERROR
    mOpis := (dbSource)->OPIS
    Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
    d1_1 := (dbSource)->DATEBEG
    d2_1 := (dbSource)->DATEEND
    Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
    d1 := hb_ValToStr(d1_1)
    d2 := hb_ValToStr(d2_1)

    count++
    cmdTextInsert += 'INSERT INTO t005(code, error, opis, datebeg, dateend) VALUES(' ;
        + "" + alltrim(str(mCode)) + "," ;
        + "'" + mError + "'," ;
        + "'" + mOpis + "'," ;
        + "'" + d1 + "'," ;
        + "'" + d2 + "');"
    if count == COMMIT_COUNT
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
      count := 0
      cmdTextInsert := textBeginTrans
    endif
    (dbSource)->(dbSkip())
  end do
  (dbSource)->(dbCloseArea())
  if count > 0
    cmdTextInsert += textCommitTrans
    sqlite3_exec(db, cmdTextInsert)
  endif
  fOut:add_string('��ࠡ�⠭� ' + str(j) + ' 㧫��.' + hb_eol() )
  return nil

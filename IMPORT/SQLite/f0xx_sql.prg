#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'
#define COMMIT_COUNT  500

// 12.08.23
function make_F0xx(db, source, fOut, fError)

  make_f006(db, source, fOut, fError)
  make_f010(db, source, fOut, fError)
  make_f011(db, source, fOut, fError)
  make_f014(db, source, fOut, fError)
  
  return nil

// 12.08.23
Function make_f006(db, source, fOut, fError)
  // IDVID,       "N",      2,      0  // ��� ���� ����஫�
  // VIDNAME,     "C",    350,      0  // ������������ ���� ����஫�
  // DATEBEG,   "D",   8, 0  // ��� ��砫� ����⢨� �����
  // DATEEND,   "D",   8, 0   // ��� ����砭�� ����⢨� �����

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDVID, mVidname, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f006(idvid INTEGER, vidname TEXT, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F006.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ����� ����஫� (VidExp)')
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS f006') == SQLITE_OK
    fOut:add_string('DROP TABLE f006 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE f006 - Ok')
  else
    fOut:add_string('CREATE TABLE f006 - False')
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
        mIDVID := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDVID')
        mVidname := read_xml_stroke_1251_to_utf8(oXmlNode, 'VIDNAME')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO f006(idvid, vidname, datebeg, dateend) VALUES(' ;
            + "" + alltrim(str(val(mIDVID))) + "," ;
            + "'" + mVidname + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
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

// 12.08.23
Function make_f010(db, source, fOut, fError)
  // KOD_TF,       "C",      2,      0  // ��� �����
  // KOD_OKATO,     "C",    5,      0  // ��� �� ����� (�ਫ������ � O002).
  // SUBNAME,     "C",    254,      0  // ������������ ��ꥪ� ��
  // OKRUG,     "N",        1,      0  // ��� 䥤�ࠫ쭮�� ���㣠
  // DATEBEG,   "D",   8, 0  // ��� ��砫� ����⢨� �����
  // DATEEND,   "D",   8, 0   // ��� ����砭�� ����⢨� �����

  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mKOD_TF, mKOD_OKATO, mSubname, mOkrug, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f010(kod_tf TEXT(2), kod_okato TEXT(5), subname TEXT, okrug INTEGER, datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F010.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ��ꥪ⮢ ���ᨩ᪮� �����樨 (Subekti)')
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS f010') == SQLITE_OK
    fOut:add_string('DROP TABLE f010 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE f010 - Ok')
  else
    fOut:add_string('CREATE TABLE f010 - False')
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
        mKOD_TF := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_TF')
        mKOD_OKATO := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_OKATO')
        mSubname := read_xml_stroke_1251_to_utf8(oXmlNode, 'SUBNAME')
        mOkrug := read_xml_stroke_1251_to_utf8(oXmlNode, 'OKRUG')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO f010(kod_tf, kod_okato, subname, okrug, datebeg, dateend) VALUES(' ;
            + "'" + mKOD_TF + "'," ;
            + "'" + mKOD_OKATO + "'," ;
            + "'" + mSubname + "'," ;
            + "" + alltrim(str(val(mOkrug))) + "," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
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

// 12.08.23
Function make_f011(db, source, fOut, fError)
  // IDDoc,       "C",      2,      0  // ��� ⨯� ���㬥��
  // DocName,     "C",    254,      0  // ������������ ⨯� ���㬥��
  // DocSer,     "C",    10,      0  // ��᪠ �ਨ ���㬥��
  // DocNum,     "C",      20,      0  // ��᪠ ����� ���㬥��
  // DATEBEG,   "D",   8, 0  // ��� ��砫� ����⢨� �����
  // DATEEND,   "D",   8, 0   // ��� ����砭�� ����⢨� �����

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mIDDoc, mDocName, mDocSer, mDocNum, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f011(iddoc TEXT(2), docname TEXT, docser TEXT(10), docnum TEXT(20), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F011.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ⨯�� ���㬥�⮢, 㤮�⮢������ ��筮��� (Tipdoc)')
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS f011') == SQLITE_OK
    fOut:add_string('DROP TABLE f011 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE f011 - Ok')
  else
    fOut:add_string('CREATE TABLE f011 - False')
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
        mIDDoc := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDDoc')
        mDocName := read_xml_stroke_1251_to_utf8(oXmlNode, 'DocName')
        mDocSer := read_xml_stroke_1251_to_utf8(oXmlNode, 'DocSer')
        mDocNum := read_xml_stroke_1251_to_utf8(oXmlNode, 'DocNum')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO f011(iddoc, docname, docser, docnum, datebeg, dateend) VALUES(' ;
            + "'" + mIDDoc + "'," ;
            + "'" + mDocName + "'," ;
            + "'" + mDocSer + "'," ;
            + "'" + mDocNum + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
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

// 12.08.23
Function make_f014(db, source, fOut, fError)

  // Kod,       "N",      3,      0  // ��� �訡��
  // IDVID,     "N",    1,      0  // ��� ���� ����஫�, १�ࢭ�� ����
  // Naim,     "C",    1000,      0  // ������������ ��稭� �⪠��
  // Osn,     "C",      20,      0  // �᭮����� �⪠��
  // Komment,     "C",      100,      0  // ��㦥��� �������਩
  // KodPG,     "C",      20,      0  // ��� �� �ଥ N ��
  // DATEBEG,   "D",   8, 0  // ��� ��砫� ����⢨� �����
  // DATEEND,   "D",   8, 0   // ��� ����砭�� ����⢨� �����

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mKod, mIDVID, mNaim, mOsn, mKomment, mKodPG, d1, d2, d1_1, d2_1
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE f014(kod INTEGER, idvid INTEGER, naim BLOB, osn TEXT(20), komment BLOB, kodpg TEXT(20), datebeg TEXT(10), dateend TEXT(10))'

  nameRef := 'F014.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ��稭 �⪠�� � ����� ����樭᪮� ����� (OplOtk)')
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS f014') == SQLITE_OK
    fOut:add_string('DROP TABLE f014 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE f014 - Ok')
  else
    fOut:add_string('CREATE TABLE f014 - False')
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
        mKod := read_xml_stroke_1251_to_utf8(oXmlNode, 'Kod')
        mIDVID := read_xml_stroke_1251_to_utf8(oXmlNode, 'IDVID')
        mNaim := read_xml_stroke_1251_to_utf8(oXmlNode, 'Naim')
        mOsn := read_xml_stroke_1251_to_utf8(oXmlNode, 'Osn')
        mKomment := read_xml_stroke_1251_to_utf8(oXmlNode, 'Komment')
        mKodPG := read_xml_stroke_1251_to_utf8(oXmlNode, 'KodPG')

        Set( _SET_DATEFORMAT, 'dd.mm.yyyy' )
        d1_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG'))
        d2_1 := ctod(read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND'))
        Set( _SET_DATEFORMAT, 'yyyy-mm-dd' )
        d1 := hb_ValToStr(d1_1)
        d2 := hb_ValToStr(d2_1)

        count++
        cmdTextInsert += 'INSERT INTO f014(kod, idvid, naim, osn, komment, kodpg, datebeg, dateend) VALUES(' ;
            + "" + alltrim(str(val(mKod))) + "," ;
            + "" + alltrim(str(val(mIDVID))) + "," ;
            + "'" + mNaim + "'," ;
            + "'" + mOsn + "'," ;
            + "'" + mKomment + "'," ;
            + "'" + mKodPG + "'," ;
            + "'" + d1 + "'," ;
            + "'" + d2 + "');"
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

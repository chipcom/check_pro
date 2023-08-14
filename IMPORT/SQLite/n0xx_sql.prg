// ��ࠢ�筨�� 䥤�ࠫ쭮�� 䮭�� ����樭᪮�� ���客���� �� ⨯� N0xx

#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'
#define COMMIT_COUNT  500

// 13.08.23
function make_N0xx(db, source, fOut, fError)

  make_n001(db, source, fOut, fError)
  make_n002(db, source, fOut, fError)
  make_n003(db, source, fOut, fError)
  make_n004(db, source, fOut, fError)
  make_n005(db, source, fOut, fError)
  make_n006(db, source, fOut, fError)
  make_n007(db, source, fOut, fError)
  make_n008(db, source, fOut, fError)
  make_n009(db, source, fOut, fError)
  make_n010(db, source, fOut, fError)
  make_n011(db, source, fOut, fError)
  make_n012(db, source, fOut, fError)
  make_n013(db, source, fOut, fError)
  make_n014(db, source, fOut, fError)
  make_n015(db, source, fOut, fError)
  make_n016(db, source, fOut, fError)
  make_n017(db, source, fOut, fError)
  make_n018(db, source, fOut, fError)
  make_n019(db, source, fOut, fError)
  make_n020(db, source, fOut, fError)
  make_n021(db, source, fOut, fError)

  return nil

// 12.05.22
function make_n001(db, source, fOut, fError)
  // ID_PrOt,    "N",  1, 0 // �����䨪��� ��⨢���������� ��� �⪠��
  // PrOt_NAME,  "C",250, 0 // ������������ ��⨢���������� ��� �⪠��
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_prot, mProt_Name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N001.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ��⨢���������� � �⪠��� (OnkPrOt)')

  cmdText := 'CREATE TABLE n001(id_prot INTEGER, prot_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

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
        mID_prot := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_PrOt')
        mProt_Name := read_xml_stroke_1251_to_utf8(oXmlNode, 'PrOt_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n001(id_prot, prot_name, datebeg, dateend) VALUES(' ;
            + "" + mID_prot + "," ;
            + "'" + mProt_Name + "'," ;
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

// 13.08.23
function make_n002(db, source, fOut, fError)
  // ID_St,      "N",  4, 0 // �����䨪��� �⠤��
  // DS_St,      "C",  5, 0 // ������� �� ���
  // KOD_St,     "C",  5, 0 // �⠤��
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_st, mDS_St, mKod_st, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N002.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� �⠤�� (OnkStad)')
  cmdText := 'CREATE TABLE n002(id_st INTEGER, ds_st TEXT(5), kod_st TEXT(5), datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

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
        mID_st := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_St')
        mDS_St := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_St')
        mKod_st := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_St')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n002(id_st, ds_st, kod_st, datebeg, dateend) VALUES(' ;
            + "" + mID_st + "," ;
            + "'" + mDS_St + "'," ;
            + "'" + mKod_St + "'," ;
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

// 12.05.22
function make_n003(db, source, fOut, fError)
  // ID_T,       "N",  4, 0 // �����䨪��� T
  // DS_T,       "C",  5, 0 // ������� �� ���
  // KOD_T,      "C",  5, 0 // ������祭�� T ��� ��������
  // T_NAME,     "C", 250, 0 // �����஢�� T ��� ��������
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_T, mDS_T, mKod_T, mT_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N003.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� Tumor (OnkT)')
  cmdText := 'CREATE TABLE n003(id_t INTEGER, ds_t TEXT(5), kod_t TEXT(5), t_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

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
        mID_t := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_T')
        mDS_t := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_T')
        mKod_t := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_T')
        mT_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'T_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n003(id_t, ds_t, kod_t, t_name, datebeg, dateend) VALUES(' ;
            + "" + mID_t + "," ;
            + "'" + mDS_t + "'," ;
            + "'" + mKod_t + "'," ;
            + "'" + mT_name + "'," ;
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

// 12.05.22
function make_n004(db, source, fOut, fError)
  // ID_N,       "N",  4, 0 // �����䨪��� N
  // DS_N,       "C",  5, 0 // ������� �� ���
  // KOD_N,      "C",  5, 0 // ������祭�� N ��� ��������
  // N_NAME,     "C",500, 0 // �����஢�� N ��� ��������
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_N, mDS_N, mKod_N, mN_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N004.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� Nodus (OnkN)')
  cmdText := 'CREATE TABLE n004(id_n INTEGER, ds_n TEXT(5), kod_n TEXT(5), n_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

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
        mID_n := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_N')
        mDS_n := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_N')
        mKod_n := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_N')
        mN_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'N_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n004(id_n, ds_n, kod_n, n_name, datebeg, dateend) VALUES(' ;
            + "" + mID_n + "," ;
            + "'" + mDS_n + "'," ;
            + "'" + mKod_n + "'," ;
            + "'" + mN_name + "'," ;
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

// 13.08.23
function make_n005(db, source, fOut, fError)
  // ID_M,       "N",  4, 0 // �����䨪��� M
  // DS_M,       "C",  5, 0 // ������� �� ���
  // KOD_M,      "C",  5, 0 // ������祭�� M ��� ��������
  // M_NAME,     "C",250, 0 // �����஢�� M ��� ��������
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_M, mDS_M, mKod_M, mM_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N005.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� Metastasis (OnkM)')
  cmdText := 'CREATE TABLE n005(id_m INTEGER, ds_m TEXT(5), kod_m TEXT(5), m_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

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
        mID_m := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_M')
        mDS_m := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_M')
        mKod_m := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_M')
        mM_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'M_NAME')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n005(id_m, ds_m, kod_m, m_name, datebeg, dateend) VALUES(' ;
            + "" + mID_m + "," ;
            + "'" + mDS_m + "'," ;
            + "'" + mKod_m + "'," ;
            + "'" + mM_name + "'," ;
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

// 14.08.23
function make_n006(db, source, fOut, fError)
  // ID_gr,      "N",  4, 0 // �����䨪��� ��ப�
  // DS_gr,      "C",  5, 0 // ������� �� ���
  // ID_St,      "N",  4, 0 // �����䨪��� �⠤��
  // ID_T,       "N",  4, 0 // �����䨪��� T
  // ID_N,       "N",  4, 0 // �����䨪��� N
  // ID_M,       "N",  4, 0 // �����䨪��� M
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_gr, mDS_gr, mID_St, mID_T, mID_N, mID_M, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N006.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - ��ࠢ�筨� ᮮ⢥��⢨� �⠤�� TNM (OnkTNM)')
  cmdText := 'CREATE TABLE n006(id_gr INTEGER, ds_gr TEXT(5), id_st INTEGER, id_t INTEGER, id_n INTEGER, id_m INTEGER, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

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
        mID_gr := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_gr')
        mDS_gr := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_gr')
        mID_St := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_ST')
        mID_T := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_T')
        mID_N := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_N')
        mID_M := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_M')
        d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
        d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

        count++
        cmdTextInsert += 'INSERT INTO n006(id_gr, ds_gr, id_st, id_t, id_n, id_m, datebeg, dateend) VALUES(' ;
            + "" + mID_gr + "," ;
            + "'" + mDS_gr + "'," ;
            + "" + mID_St + "," ;
            + "" + mID_T + "," ;
            + "" + mID_M + "," ;
            + "" + mID_N + "," ;
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

// 14.08.23
function make_n007(db, source, fOut, fError)
  // ID_Mrf,     "N",  2, 0 // �����䨪��� ���⮫����᪮�� �ਧ����
  // Mrf_NAME,   "C",250, 0 // ������������ ���⮫����᪮�� �ਧ����
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_Mrf, mMrf_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N007.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ���⮫����᪨� �ਧ����� (OnkMrf)')
  cmdText := 'CREATE TABLE n007(id_mrf INTEGER, mrf_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n007(id_mrf, mrf_name, datebeg, dateend) VALUES( :id_mrf, :mrf_name, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_mrf := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Mrf')
          mMrf_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'Mrf_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_mrf)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mMrf_name) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n007(id_mrf, mrf_name, datebeg, dateend) VALUES( :id_mrf, :mrf_name, :datebeg, :dateend )"
        count++
        cmdTextInsert += 'INSERT INTO n007(id_mrf, mrf_name, datebeg, dateend) VALUES(' ;
            + "" + mID_mrf + "," ;
            + "'" + mMrf_name + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n008(db, source, fOut, fError)
  // ID_R_M,     "N",  3, 0 // �����䨪��� �����
  // ID_Mrf,     "N",  2, 0 // �����䨪��� ���⮫����᪮�� �ਧ���� � ᮮ⢥��⢨� � N007
  // R_M_NAME,   "C",250, 0 // ������������ १���� ���⮫����᪮�� ��᫥�������
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_Mrf, mID_r_m, mR_M_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N008.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� १���⮢ ���⮫����᪨� ��᫥������� (OnkMrfRt)')
  cmdText := 'CREATE TABLE n008(id_r_m INTEGER, id_mrf INTEGER, r_m_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n008(id_r_m, id_mrf, r_m_name, datebeg, dateend) VALUES( :id_r_m, :id_mrf, :r_m_name, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_r_m := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_R_M')
          mID_Mrf := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Mrf')
          mR_m_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'R_M_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_r_m)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_int(stmt, 2, val(mID_Mrf)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, mR_M_name) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n008(id_r_m, id_mrf, r_m_name, datebeg, dateend) VALUES( :id_r_m, :id_mrf, :r_m_name, :datebeg, :dateend )"
          count++
          cmdTextInsert += 'INSERT INTO n008(id_r_m, id_mrf, r_m_name, datebeg, dateend) VALUES(' ;
              + "" + mID_r_m + "," ;
              + "" + mID_Mrf + "," ;
              + "'" + mR_M_name + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n009(db, source, fOut, fError)
  // ID_M_D,     "N",  2, 0 // �����䨪��� ��ப�
  // DS_Mrf,     "C",  3, 0 // ������� �� ���
  // ID_Mrf,     "N",  2, 0 // �����䨪��� ���⮫����᪮�� �ਧ���� � ᮮ⢥��⢨� � N007
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_Mrf, mID_m_d, mDS_mrf, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N009.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ᮮ⢥��⢨� ���⮫����᪨� �ਧ����� ��������� (OnkMrtDS)')
  cmdText := 'CREATE TABLE n009(id_m_d INTEGER, ds_mrf TEXT(3), id_mrf INTEGER, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n009(id_m_d, ds_mrf, id_mrf, datebeg, dateend) VALUES( :id_m_d, :ds_mrf, :id_mrf, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_m_d := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_M_D')
          mDS_mrf := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_Mrf')
          mID_Mrf := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Mrf')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_m_d)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mDS_mrf) == SQLITE_OK .AND. ;
          //   sqlite3_bind_int(stmt, 3, val(mID_Mrf)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n009(id_m_d, ds_mrf, id_mrf, datebeg, dateend) VALUES( :id_m_d, :ds_mrf, :id_mrf, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n009(id_m_d, ds_mrf, id_mrf, datebeg, dateend) VALUES(' ;
        + "" + mID_m_d + "," ;
        + "'" + mDS_Mrf + "'," ;
        + "" + mID_Mrf + "," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n010(db, source, fOut, fError)
  // ID_Igh,     "N",  2, 0 // �����䨪��� ��થ�
  // KOD_Igh,    "C",250, 0 // ������祭�� ��થ�
  // Igh_NAME,   "C",250, 0 // ������������ ��થ�
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_igh, mKOD_igh, mIgh_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N010.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ��થ஢ (OnkIgh)')
  cmdText := 'CREATE TABLE n010(id_igh INTEGER, kod_igh TEXT, igh_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n010(id_igh, kod_igh, igh_name, datebeg, dateend) VALUES( :id_igh, :kod_igh, :igh_name, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Igh')
          mKOD_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_Igh')
          mIgh_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'Igh_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_igh)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mKOD_igh) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, mIgh_name) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n010(id_igh, kod_igh, igh_name, datebeg, dateend) VALUES( :id_igh, :kod_igh, :igh_name, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n010(id_igh, kod_igh, igh_name, datebeg, dateend) VALUES(' ;
        + "" + mID_igh + "," ;
        + "'" + mKOD_igh + "'," ;
        + "'" + mIgh_name + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n011(db, source, fOut, fError)
  // ID_R_I,     "N",  3, 0 // �����䨪��� �����
  // ID_Igh,     "N",  2, 0 // �����䨪��� ��થ� � ᮮ⢥��⢨� � N010
  // KOD_R_I,    "C",250, 0 // ������祭�� १����
  // R_I_NAME,   "C",250, 0 // ������������ १����
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_R_I, mID_igh, mKOD_R_I, mR_I_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N011.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ���祭�� ��થ஢ (OnkIghRt)')
  cmdText := 'CREATE TABLE n011(id_r_i INTEGER, id_igh INTEGER, kod_r_i TEXT, r_i_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n011(id_r_i, id_igh, kod_r_i, r_i_name, datebeg, dateend) VALUES( :id_r_i, :id_igh, :kod_r_i, :r_i_name, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_R_I := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_R_I')
          mID_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Igh')
          mKOD_r_i := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD_R_I')
          mR_I_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'R_I_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_R_I)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_int(stmt, 2, val(mID_igh)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, mKOD_r_i) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, mR_I_name) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 5, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 6, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n011(id_r_i, id_igh, kod_r_i, r_i_name, datebeg, dateend) VALUES( :id_r_i, :id_igh, :kod_r_i, :r_i_name, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n011(id_r_i, id_igh, kod_r_i, r_i_name, datebeg, dateend) VALUES(' ;
        + "" + mID_R_I + "," ;
        + "" + mID_igh + "," ;
        + "'" + mKOD_r_i + "'," ;
        + "'" + mR_I_name + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n012(db, source, fOut, fError)
  // ID_I_D,     "N",  2, 0 // �����䨪��� ��ப�
  // DS_Igh,     "C",  3, 0 // ������� �� ���
  // ID_Igh,     "N",  2, 0 // �����䨪��� ��થ� � ᮮ⢥��⢨� � N010
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_I_D, mID_igh, mDS_Igh, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N012.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ᮮ⢥��⢨� ��થ஢ ��������� (OnkIghDS)')
  cmdText := 'CREATE TABLE n012(id_i_d INTEGER, ds_igh TEXT(3), id_igh INTEGER, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n012(id_i_d, ds_igh, id_igh, datebeg, dateend) VALUES( :id_i_d, :ds_igh, :id_igh, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_I_D := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_I_D')
          mDS_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'DS_Igh')
          mID_igh := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Igh')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_I_D)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mDS_Igh) == SQLITE_OK .AND. ;
          //   sqlite3_bind_int(stmt, 3, val(mID_igh)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n012(id_i_d, ds_igh, id_igh, datebeg, dateend) VALUES( :id_i_d, :ds_igh, :id_igh, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n012(id_i_d, ds_igh, id_igh, datebeg, dateend) VALUES(' ;
        + "" + mID_I_D + "," ;
        + "'" + mDS_Igh + "'," ;
        + "" + mID_igh + "," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
  endif
  return nil

// 12.05.22
function make_n013(db, source, fOut, fError)
  // ID_TLech,   "N",  1, 0 // �����䨪��� ⨯� ��祭��
  // TLech_NAME, "C",250, 0 // ������������ ⨯� ��祭��
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_tlech, mTlech_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N013.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ⨯�� ��祭�� (OnkLech)')
  cmdText := 'CREATE TABLE n013(id_tlech INTEGER, tlech_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n013(id_tlech, tlech_name, datebeg, dateend) VALUES( :id_tlech, :tlech_name, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_tlech := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_Tlech')
          mTlech_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'Tlech_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_tlech)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mTlech_name) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n013(id_tlech, tlech_name, datebeg, dateend) VALUES( :id_tlech, :tlech_name, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n013(id_tlech, tlech_name, datebeg, dateend) VALUES(' ;
        + "" + mID_tlech + "," ;
        + "'" + mTlech_name + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n014(db, source, fOut, fError)
  // ID_THir,    "N",  1, 0 // �����䨪��� ⨯� ���ࣨ�᪮�� ��祭��
  // THir_NAME,  "C",250, 0 // ������������ ⨯� ���ࣨ�᪮�� ��祭��
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_thir, mThir_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N014.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ⨯�� ���ࣨ�᪮�� ��祭�� (OnkHir)')
  cmdText := 'CREATE TABLE n014(id_thir INTEGER, thir_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n014(id_thir, thir_name, datebeg, dateend) VALUES( :id_thir, :thir_name, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_thir := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_THir')
          mThir_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'THir_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_thir)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mThir_name) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n014(id_thir, thir_name, datebeg, dateend) VALUES( :id_thir, :thir_name, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n014(id_thir, thir_name, datebeg, dateend) VALUES(' ;
        + "" + mID_thir + "," ;
        + "'" + mThir_name + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n015(db, source, fOut, fError)
  // ID_TLek_L,  "N",  1, 0 // �����䨪��� ����� ������⢥���� �࠯��
  // TLek_NAME_L,"C",250, 0 // ������������ ����� ������⢥���� �࠯��
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_tlek_l, mTlek_name_l, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N015.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ����� ������⢥���� �࠯�� (OnkLek_L)')
  cmdText := 'CREATE TABLE n015(id_tlek_l INTEGER, tlek_name_l TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n015(id_tlek_l, tlek_name_l, datebeg, dateend) VALUES( :id_tlek_l, :tlek_name_l, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_tlek_l := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TLek_L')
          mTlek_name_l := read_xml_stroke_1251_to_utf8(oXmlNode, 'TLek_NAME_L')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_tlek_l)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mTlek_name_l) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n015(id_tlek_l, tlek_name_l, datebeg, dateend) VALUES( :id_tlek_l, :tlek_name_l, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n015(id_tlek_l, tlek_name_l, datebeg, dateend) VALUES(' ;
        + "" + mID_tlek_l + "," ;
        + "'" + mTlek_name_l + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n016(db, source, fOut, fError)
  // ID_TLek_V,  "N",  1, 0 // �����䨪��� 横�� ������⢥���� �࠯��
  // TLek_NAME_V,"C",250, 0 // ������������ 横�� ������⢥���� �࠯��
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_tlek_v, mTlek_name_v, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N016.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� 横��� ������⢥���� �࠯�� (OnkLek_V)')
  cmdText := 'CREATE TABLE n016(id_tlek_v INTEGER, tlek_name_v TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n016(id_tlek_v, tlek_name_v, datebeg, dateend) VALUES( :id_tlek_v, :tlek_name_v, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_tlek_v := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TLek_V')
          mTlek_name_v := read_xml_stroke_1251_to_utf8(oXmlNode, 'TLek_NAME_V')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_tlek_v)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mTlek_name_v) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n016(id_tlek_v, tlek_name_v, datebeg, dateend) VALUES( :id_tlek_v, :tlek_name_v, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n016(id_tlek_v, tlek_name_v, datebeg, dateend) VALUES(' ;
        + "" + mID_tlek_v + "," ;
        + "'" + mTlek_name_v + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n017(db, source, fOut, fError)
  // ID_TLuch,  "N",  1, 0 // �����䨪��� ⨯� ��祢�� �࠯��
  // TLuch_NAME,"C",250, 0 // ������������ ⨯� ��祢�� �࠯��
  // DATEBEG,    "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,    "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_tluch, mTluch_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N017.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ⨯�� ��祢�� �࠯�� (OnkLuch)')
  cmdText := 'CREATE TABLE n017(id_tluch INTEGER, tluch_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n017(id_tluch, tluch_name, datebeg, dateend) VALUES( :id_tluch, :tluch_name, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_tluch := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_TLuch')
          mTluch_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'TLuch_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_tluch)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mTluch_name) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n017(id_tluch, tluch_name, datebeg, dateend) VALUES( :id_tluch, :tluch_name, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n017(id_tluch, tluch_name, datebeg, dateend) VALUES(' ;
        + "" + mID_tluch + "," ;
        + "'" + mTluch_name + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n018(db, source, fOut, fError)
  // ID_REAS,   "N",  2, 0 // �����䨪��� ������ ���饭��
  // REAS_NAME, "C",300, 0 // ������������ ������ ���饭��
  // DATEBEG,   "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,   "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_reas, mReas_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N018.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ������� ���饭�� (OnkReas)')
  cmdText := 'CREATE TABLE n018(id_reas INTEGER, reas_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n018(id_reas, reas_name, datebeg, dateend) VALUES( :id_reas, :reas_name, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_reas := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_REAS')
          mReas_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'REAS_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_reas)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mReas_name) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n018(id_reas, reas_name, datebeg, dateend) VALUES( :id_reas, :reas_name, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n018(id_reas, reas_name, datebeg, dateend) VALUES(' ;
        + "" + mID_reas + "," ;
        + "'" + mReas_name + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n019(db, source, fOut, fError)
  // ID_CONS,   "N",  1, 0 // �����䨪��� 楫� ���ᨫ�㬠
  // CONS_NAME, "C",300, 0 // ������������ 楫� ���ᨫ�㬠
  // DATEBEG,   "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,   "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_cons, mCons_name, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N019.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� 楫�� ���ᨫ�㬠 (OnkCons)')
  cmdText := 'CREATE TABLE n019(id_cons INTEGER, cons_name TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n019(id_cons, cons_name, datebeg, dateend) VALUES( :id_cons, :cons_name, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_cons := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_CONS')
          mCons_name := read_xml_stroke_1251_to_utf8(oXmlNode, 'CONS_NAME')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_cons)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mCons_name) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n019(id_cons, cons_name, datebeg, dateend) VALUES( :id_cons, :cons_name, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n019(id_cons, cons_name, datebeg, dateend) VALUES(' ;
        + "" + mID_cons + "," ;
        + "'" + mCons_name + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n020(db, source, fOut, fError)
  // ID_LEKP,   "C",  6, 0 // �����䨪��� ������⢥����� �९���
  // MNN,       "C",300, 0 // ����㭠த��� ����⥭⮢����� ������������ ������⢥����� �९��� (���)
  // DATEBEG,   "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,   "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_lekp, mMNN, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N020.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ������⢥���� �९��⮢, �ਬ��塞�� �� �஢������ ������⢥���� �࠯�� (OnkLekp)')
  cmdText := 'CREATE TABLE n020(id_lekp TEXT(6), mnn TEXT, datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n020(id_lekp, mnn, datebeg, dateend) VALUES( :id_lekp, :mnn, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_lekp := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_LEKP')
          mMNN := read_xml_stroke_1251_to_utf8(oXmlNode, 'MNN')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_text(stmt, 1, mID_lekp) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mMNN) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n020(id_lekp, mnn, datebeg, dateend) VALUES( :id_lekp, :mnn, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n020(id_lekp, mnn, datebeg, dateend) VALUES(' ;
        + "'" + mID_lekp + "'," ;
        + "'" + mMNN + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.05.22
function make_n021(db, source, fOut, fError)
  // ID_ZAP,    "N",  4, 0 // �����䨪��� ����� (� ���ᠭ�� Char 15)
  // CODE_SH,   "C", 10, 0 // ��� �奬� ������⢥���� �࠯��
  // ID_LEKP,   "C",  6, 0 // �����䨪��� ������⢥����� �९���, �ਬ��塞��� �� �஢������ ������⢥���� ��⨢����宫���� �࠯��. ���������� � ᮮ⢥��⢨� � N020
  // DATEBEG,   "D",  8, 0 // ��� ��砫� ����⢨� �����
  // DATEEND,   "D",  8, 0 // ��� ����砭�� ����⢨� �����
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mID_zap, mCode_sh, mID_lekp, d1, d2
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  nameRef := 'N021.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  endif

  fOut:add_string(hb_eol() + nameRef + ' - �����䨪��� ᮮ⢥��⢨� ������⢥����� �९��� �奬� ������⢥���� �࠯�� (OnkLpsh)')
  cmdText := 'CREATE TABLE n021(id_zap INTEGER, code_sh TEXT(10), id_lekp TEXT(6), datebeg TEXT(10), dateend TEXT(10))'
  if ! create_table(db, nameref, cmdText, fOut, fError)
    return nil
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO n021(id_zap, code_sh, id_lekp, datebeg, dateend) VALUES( :id_zap, :code_sh, :id_lekp, :datebeg, :dateend )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mID_zap := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_ZAP')
          mCode_sh := read_xml_stroke_1251_to_utf8(oXmlNode, 'CODE_SH')
          mId_lekp := read_xml_stroke_1251_to_utf8(oXmlNode, 'ID_LEKP')
          d1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEBEG')
          d2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'DATEEND')

          // if sqlite3_bind_int(stmt, 1, val(mID_zap)) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 2, mCode_sh) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 3, mID_lekp) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 4, d1) == SQLITE_OK .AND. ;
          //   sqlite3_bind_text(stmt, 5, d2) == SQLITE_OK
          //   if sqlite3_step(stmt) != SQLITE_DONE
          //     out_error(fError, TAG_ROW_INVALID, nfile, j)
          //   endif
          // endif
          // sqlite3_reset(stmt)
    // cmdText := "INSERT INTO n021(id_zap, code_sh, id_lekp, datebeg, dateend) VALUES( :id_zap, :code_sh, :id_lekp, :datebeg, :dateend )"
    count++
    cmdTextInsert += 'INSERT INTO n021(id_zap, code_sh, id_lekp, datebeg, dateend) VALUES(' ;
        + "" + mID_zap + "," ;
        + "'" + mCode_sh + "'," ;
        + "'" + mID_lekp + "'," ;
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
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k) + ' 㧫��.' + hb_eol() )
  endif
  return nil

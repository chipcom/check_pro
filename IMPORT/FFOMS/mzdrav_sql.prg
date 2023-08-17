/// ��ࠢ�筨�� ��������⢠ ��ࠢ���࠭���� ��

#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'
#define COMMIT_COUNT  500

// 31.01.23
function make_mzdrav(db, source, fOut, fError)

  make_severity(db, source, fOut, fError)
  make_ed_izm(db, source, fOut, fError)
  make_implant(db, source, fOut, fError)
  make_MethIntro(db, source, fOut, fError)
  
  sqlite3_exec(db, 'DROP TABLE IF EXISTS tmp')

  // make_uslugi_mz(db, source, fOut, fError) // �� �ᯮ��㥬 (��� ����饣�)

  return nil

// 12.08.23
function make_severity(db, source, fOut, fError)
  local cmdText
  local nfile, nameRef
  local k, j, k1, j1
  local oXmlDoc, oXmlNode, oNode1
  local mID, mName, mSYN, mSCTID, mSort
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  // 1) ID, ��� , �����᫥���, 㭨����� �����䨪���, �������� ���祭�� ? 楫� �᫠ �� 1 �� 6;
  // 2) NAME, ������ ��������, �����, ��易⥫쭮� ����, ⥪�⮢� �ଠ�;
  // 3) SYN, ��������, �����, ᨭ����� �ନ��� �ࠢ�筨��, ⥪�⮢� �ଠ�;
  // 4) SCTID, ��� SNOMED CT , �����, ᮮ⢥�����騩 ��� ������������;
  // 5) SORT, ����஢�� , �����᫥���, �ਢ������ ������ � ���浪���� 誠�� ��� 㯮�冷稢���� �ନ���
  //    �ࠢ�筨�� �� ����� ������ � ����� �殮��� �⥯��� �殮�� ���ﭨ�, 楫�� �᫮ �� 1 �� 7;
  cmdText := 'CREATE TABLE Severity( id INTEGER, name TEXT(40), syn TEXT(50), sctid INTEGER, sort INTEGER )'
  
  nameRef := '1.2.643.5.1.13.13.11.1006.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - �⥯��� �殮�� ���ﭨ� ��樥�� (OID)')
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE IF EXISTS Severity') == SQLITE_OK
    fOut:add_string('DROP TABLE Severity - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
     fOut:add_string('CREATE TABLE Severity - Ok')
  else
     fOut:add_string('CREATE TABLE Severity - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty(oXmlDoc:aItems)
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('��ࠡ�⪠ - ' + nfile)
    k := Len(oXmlDoc:aItems[1]:aItems)
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          if "ENTRY" == upper(oNode1:title)
            mID := Hb_Translate(mo_read_xml_stroke(oNode1, 'ID', , , 'utf8'), 'UTF8', 'CP866')
            mName := Hb_Translate(mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8'), 'UTF8', 'CP866')
            mSYN := Hb_Translate(mo_read_xml_stroke(oNode1, 'SYN', , , 'utf8'), 'UTF8', 'CP866')
            mSCTID := Hb_Translate(mo_read_xml_stroke(oNode1, 'SCTID', , , 'utf8'), 'UTF8', 'CP866')
            mSort := Hb_Translate(mo_read_xml_stroke(oNode1, 'SORT', , , 'utf8'), 'UTF8', 'CP866')

            count++
            cmdTextInsert += 'INSERT INTO Severity(id, name, syn, sctid, sort) VALUES(' ;
                + "" + alltrim(str(val(mID))) + "," ;
                + "'" + mName + "'," ;
                + "'" + mSYN + "'," ;
                + "'" + mSCTID + "'," ;
                + "" + alltrim(str(val(mSort))) + ");"
            if count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec(db, cmdTextInsert)
              count := 0
              cmdTextInsert := textBeginTrans
            endif
          endif
        next j1
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
Function make_ed_izm(db, source, fOut, fError)
  local cmdText
  local oXmlDoc, oXmlNode, oNode1
  local nfile, nameRef
  local k, j, k1, j1
  local mID, mFullName, mShortName
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  // 1) ID, �������� �����䨪���, �����᫥���, �������� �����䨪��� ������� ����७�� ������୮�� ���;
  // 2) FULLNAME, ������ ������������, �����;
  // 3) SHORTNAME, ��⪮� ������������, �����;
  // 4) PRINTNAME, ������������ ��� ����, �����;
  // 5) MEASUREMENT, �����୮���, �����;
  // 6) UCUM, ��� UCUM, �����;
  // 7) COEFFICIENT, �����樥�� ������, �����, �����樥�� ������ � ࠬ��� ����� ࠧ��୮��.;
  // 8) FORMULA, ���㫠 ������, �����, � �����饩 ���ᨨ �ࠢ�筨�� �� �ᯮ������.;
  // 9) CONVERSION_ID, ��� ������� ����७�� ��� ������, �����᫥���, ��� ������� ����७��, � ������ �����⢫���� ������.;
  // 10) CONVERSION_NAME, ������ ����७�� ��� ������, �����, ��⪮� ������������ ������� ����७��, � ������ �����⢫���� ������.;
  // 11) OKEI_CODE, ��� ����, �����, ���⢥�����騩 ��� �����ᨩ᪮�� �����䨪��� ������ ����७��.;
  // // 12) NSI_CODE_EEC, ��� �ࠢ�筨�� ����, �����, ����易⥫쭮� ���� ? ��� �ࠢ�筨�� ॥��� ��� ����;
  // // 13) NSI_ELEMENT_CODE_EEC, ��� ����� �ࠢ�筨�� ����, �����, ����易⥫쭮� ���� ? ��� ����� �ࠢ�筨�� ॥��� ��� ����;
  // cmdText := 'CREATE TABLE ed_izm( id INTEGER, fullname TEXT(40), ' + ;
  //   'shortname TEXT(25), prnname TEXT(25), measur TEXT(45), ucum TEXT(15), coef TEXT(15), ' + ;
  //   'conv_id INTEGER, conv_nam TEXT(25), okei_cod INTEGER )'
  cmdText := 'CREATE TABLE ed_izm(id INTEGER, fullname TEXT(40), shortname TEXT(25))'
    
  nameRef := '1.2.643.5.1.13.13.11.1358.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - ������� ����७�� (OID)')
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE IF EXISTS ed_izm') == SQLITE_OK
    fOut:add_string('DROP TABLE ed_izm - Ok')
  endif
     
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE ed_izm - Ok')
  else
    fOut:add_string('CREATE TABLE ed_izm - False')
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
      if 'ENTRIES' == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          if 'ENTRY' == upper(oNode1:title)
            mID := Hb_Translate(mo_read_xml_stroke(oNode1, 'ID', , , 'UTF8'), 'UTF8', 'CP866')
            mFullName := Hb_Translate(mo_read_xml_stroke(oNode1, 'FULLNAME', , , 'UTF8'), 'UTF8', 'CP866')
            mShortName := Hb_Translate(mo_read_xml_stroke(oNode1, 'SHORTNAME', , , 'UTF8'), 'UTF8', 'CP866')

            count++
            if mShortName == "'"
              cmdTextInsert += 'INSERT INTO ed_izm(id, fullname, shortname) VALUES(' ;
                  + '' + alltrim(str(val(mID))) + ',' ;
                  + '"' + mFullName + '",' ;
                  + '"' + mShortName + '");'
            else
              cmdTextInsert += "INSERT INTO ed_izm(id, fullname, shortname) VALUES(" ;
                  + "" + alltrim(str(val(mID))) + "," ;
                  + "'" + mFullName + "'," ;
                  + "'" + mShortName + "');"
            endif
            if count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec(db, cmdTextInsert)
              count := 0
              cmdTextInsert := textBeginTrans
            endif
          endif
        next j1
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    fOut:add_string('��ࠡ�⠭� ' + str(k1) + ' 㧫��.' + hb_eol() )
  endif
  return nil

// 12.08.23
Function make_MethIntro(db, source, fOut, fError)
  local cmdText, cmdTextTMP
  local k, j, k1, j1
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID, mNameRus, mNameEng, mParent, mType
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans
  local countTmp := 0, cmdTextInsertTmp := textBeginTrans

  // 1) ID, ���, �����᫥���, 㭨����� �����䨪���, ��易⥫쭮� ����, 楫�� �᫮;
  // 2) NAME_RUS, ���� �������� �� ���᪮� �몥, �����, ������������ ��� �������� ������⢥���� �।�� �� ���᪮� �몥, ��易⥫쭮� ����, ⥪�⮢� �ଠ�;
  // 3) NAME_ENG, ���� �������� �� ������᪮� �몥, �����, ������������ ��� �������� ������⢥���� �।�� �� ������᪮� �몥, ��易⥫쭮� ����, ⥪�⮢� �ଠ�;
  // 4) PARENT, ����⥫�᪨� 㧥�, �����᫥���, த�⥫�᪨� 㧥� ������᪮�� �ࠢ�筨��, 楫�� �᫮;
  // // 5) NSI_CODE_EEC, ��� �ࠢ�筨�� ����, �����, ����易⥫쭮� ���� ? ��� �ࠢ�筨�� ॥��� ��� ����;
  // // 6) NSI_ELEMENT_CODE_EEC, ��� ����� �ࠢ�筨�� ����, �����, ����易⥫쭮� ���� ? ��� ����� �ࠢ�筨�� ॥��� ��� ����;
  // ++) TYPE, ��� �����, ᨬ�����: 'O' ��୥��� 㧥�, 'U' 㧥�, 'L' ������ �����
  cmdText := 'CREATE TABLE MethIntro(id INTEGER, name_rus TEXT(30), name_eng TEXT(30), parent INTEGER, type TEXT(1))'
    
  nameRef := "1.2.643.5.1.13.13.11.1468.xml"
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + " - ��� �������� ������⢥���� �९��⮢, � ⮬ �᫥ ��� �죮⭮�� ���ᯥ祭�� �ࠦ��� ������⢥��묨 �।�⢠�� (MethIntro)" + hb_eol())
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE MethIntro') == SQLITE_OK
    fOut:add_string('DROP TABLE MethIntro - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE MethIntro - Ok')
  else
    fOut:add_string('CREATE TABLE MethIntro - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // �६����� ⠡��� ��� ���쭥�襣� �ᯮ�짮�����
    cmdTextTMP := 'CREATE TABLE tmp( id INTEGER, parent INTEGER)'
    sqlite3_exec(db, 'DROP TABLE IF EXISTS tmp')
    sqlite3_exec(db, cmdTextTMP)
    
    fOut:add_string('��ࠡ�⪠ - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if "ENTRIES" == upper(oXmlNode:title)
        k1 := len(oXmlNode:aItems)
        for j1 := 1 to k1
          oNode1 := oXmlNode:aItems[j1]
          if "ENTRY" == upper(oNode1:title)
            mID := Hb_Translate(mo_read_xml_stroke(oNode1, 'ID', , , 'utf8'), 'UTF8', 'CP866')
            mNameRus := Hb_Translate(mo_read_xml_stroke(oNode1, 'NAME_RUS', , , 'utf8'), 'UTF8', 'CP866')
            mNameEng := Hb_Translate(mo_read_xml_stroke(oNode1, 'NAME_ENG', , , 'utf8'), 'UTF8', 'CP866')
            mParent := Hb_Translate(mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8'), 'UTF8', 'CP866')

            count++
            cmdTextInsert += 'INSERT INTO MethIntro(id, name_rus, name_eng, parent) VALUES(' ;
                + '' + alltrim(str(val(mID))) + ',' ;
                + '"' + mNameRus + '",' ;
                + '"' + mNameEng + '",' ;
                + '' + alltrim(str(val(mParent))) + ');'
            if count == COMMIT_COUNT
              cmdTextInsert += textCommitTrans
              sqlite3_exec(db, cmdTextInsert)
              count := 0
              cmdTextInsert := textBeginTrans
            endif
            countTmp++
            cmdTextInsertTmp += 'INSERT INTO tmp(id, parent) VALUES(' ;
              + '' + alltrim(str(val(mID))) + ',' ;
              + '' + alltrim(str(val(mParent))) + ');'
            if countTmp == COMMIT_COUNT
              cmdTextInsertTmp += textCommitTrans
              sqlite3_exec(db, cmdTextInsertTmp)
              countTmp := 0
              cmdTextInsertTmp := textBeginTrans
            endif
          endif
        next j1
      endif
    next j
    if count > 0
      cmdTextInsert += textCommitTrans
      sqlite3_exec(db, cmdTextInsert)
    endif
    if countTmp > 0
      cmdTextInsertTmp += textCommitTrans
      sqlite3_exec(db, cmdTextInsertTmp)
    endif

    cmdText := "UPDATE MethIntro SET type = 'U' WHERE EXISTS (SELECT 1 FROM tmp WHERE MethIntro.id = tmp.parent)"
    if sqlite3_exec(db, cmdText) == SQLITE_OK
      fOut:add_string(hb_eol() + cmdText + ' - Ok')
    else
      OutErr(hb_eol() + cmdText + ' - False')
    endif
    cmdText := "UPDATE MethIntro SET type = 'L' WHERE NOT EXISTS (SELECT 1 FROM tmp WHERE MethIntro.id = tmp.parent)"
    if sqlite3_exec(db, cmdText) == SQLITE_OK
      fOut:add_string(hb_eol() + cmdText + ' - Ok')
    else
      OutErr(hb_eol() + cmdText + ' - False')
    endif
    sqlite3_exec(db, 'DROP TABLE IF EXISTS tmp')
    fOut:add_string('��ࠡ�⠭� ' + str(k1) + ' 㧫��.' + hb_eol() )
  endif
  return NIL

// 31.01.23
function make_implant(db, source, fOut, fError)
  local cmdText, cmdTextTMP
  local k, j, k1, j1
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1
  local mID, mName, mRZN, mParent, mType  //, mLocal, mMaterial, mOrder
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans
  local countTmp := 0, cmdTextInsertTmp := textBeginTrans

  // 1)ID, ��� , 㭨����� �����䨪��� �����;
  // 2)RZN, ��᧤ࠢ������ , ��� ������� ᮣ��᭮ ����������୮�� �����䨪���� ��᧤ࠢ������;
  // 3)PARENT, ��� த�⥫�᪮�� �����;
  // 4)NAME, ������������ , ������������ ���� �������;
  // 5)ACTUAL, ���㠫쭮���, �����᪨�;
  // 6)EXISTENCE_NPA, �ਧ��� ������ ���, �����᪨�
  // // 5)LOCALIZATION, ���������� , ���⮬��᪠� �������, � ���ன �⭮���� ���������� �/��� ����⢨� �������;
  // // 6)MATERIAL, ���ਠ� , ⨯ ���ਠ��, �� ���ண� ����⮢���� �������;
  // // 7)METAL, ��⠫� , �ਧ��� ������ ��⠫�� � �������;
  // // 8)SCTID, ��� SNOMED CT , 㭨����� ��� �� ����������� ������᪨� �ନ��� SNOMED CT;
  // // 9)ORDER, ���冷� ���஢�� ;
  // ++) TYPE, ��� �����, ᨬ�����: 'O' ��୥��� 㧥�, 'U' 㧥�, 'L' ������ �����
  // cmdText := 'CREATE TABLE implantant( id INTEGER, rzn INTEGER, parent INTEGER, name TEXT(120), local TEXT(80), material TEXT(20), _order INTEGER, type TEXT(1) )'
  cmdText := 'CREATE TABLE implantant(id INTEGER, rzn INTEGER, parent INTEGER, name TEXT(120), type TEXT(1))'
    
  nameRef := '1.2.643.5.1.13.13.11.1079.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - ���� ����樭᪨� �������, ��������㥬�� � �࣠���� 祫�����, � ���� ���ன�� ��� ��樥�⮢ � ��࠭�祭�묨 ����������ﬨ (OID)')
  endif

  stat_msg('��ࠡ�⪠ 䠩��: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE implantant') == SQLITE_OK
    fOut:add_string('DROP TABLE implantant - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE implantant - Ok')
  else
    fOut:add_string('CREATE TABLE implantant - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // �६����� ⠡��� ��� ���쭥�襣� �ᯮ�짮�����
    cmdTextTMP := 'CREATE TABLE tmp(id INTEGER, parent INTEGER)'
    sqlite3_exec(db, 'DROP TABLE IF EXISTS tmp')
    sqlite3_exec(db, cmdTextTMP)

    // cmdTextTMP := 'INSERT INTO tmp(id, parent) VALUES (:id, :parent)'
    // stmtTMP := sqlite3_prepare(db, cmdTextTMP)
    // cmdText := 'INSERT INTO implantant (id, rzn, parent, name, type) VALUES(:id, :rzn, :parent, :name, :type)'
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty( stmt )
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len(oXmlDoc:aItems[1]:aItems)
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              mID := Hb_Translate(mo_read_xml_stroke(oNode1, 'ID', , , 'utf8'), 'UTF8', 'CP866')
              mRZN := Hb_Translate(mo_read_xml_stroke(oNode1, 'RZN', , , 'utf8'), 'UTF8', 'CP866')
              mParent := Hb_Translate(mo_read_xml_stroke(oNode1, 'PARENT', , , 'utf8'), 'UTF8', 'CP866')
              mName := Hb_Translate(mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8'), 'UTF8', 'CP866')
  
              // if sqlite3_bind_int(stmt, 1, val(mID)) == SQLITE_OK .AND. ;
              //         sqlite3_bind_int(stmt, 2, val(mRZN)) == SQLITE_OK .AND. ;
              //         sqlite3_bind_int(stmt, 3, val(mParent)) == SQLITE_OK  .AND. ;
              //         sqlite3_bind_text(stmt, 4, mName) == SQLITE_OK  // .AND. ;
              //         // sqlite3_bind_text(stmt, 5, mLocal) == SQLITE_OK .AND. ;
              //         // sqlite3_bind_text(stmt, 6, mMaterial) == SQLITE_OK .AND. ;
              //         // sqlite3_bind_int(stmt, 7, val(mOrder)) == SQLITE_OK
              //   if sqlite3_step(stmt) != SQLITE_DONE
              //     out_error(fError, TAG_ROW_INVALID, nfile, j)
              //   endif
              // endif
              // sqlite3_reset(stmt)
    // cmdText := 'INSERT INTO implantant (id, rzn, parent, name, type) VALUES(:id, :rzn, :parent, :name, :type)'
              count++
              cmdTextInsert += 'INSERT INTO implantant(id, rzn, parent, name) VALUES(' ;
                  + '' + alltrim(str(val(mID))) + ',' ;
                  + '' + alltrim(str(val(mRZN))) + ',' ;
                  + '' + alltrim(str(val(mParent))) + ',' ;
                  + '"' + mName + '");'
              if count == COMMIT_COUNT
                cmdTextInsert += textCommitTrans
                sqlite3_exec(db, cmdTextInsert)
                count := 0
                cmdTextInsert := textBeginTrans
              endif

              // if sqlite3_bind_int(stmtTMP, 1, val(mID)) == SQLITE_OK .AND. ;
              //   sqlite3_bind_int(stmtTMP, 2, val(mParent)) == SQLITE_OK
              //   if sqlite3_step(stmtTMP) != SQLITE_DONE
              //     out_error(fError, TAG_ROW_INVALID, nfile, j)
              //   endif
              //   sqlite3_reset(stmtTMP)
              // endif
    // cmdTextTMP := 'INSERT INTO tmp(id, parent) VALUES (:id, :parent)'
              countTmp++
              cmdTextInsertTmp += 'INSERT INTO tmp(id, parent) VALUES(' ;
                  + '' + alltrim(str(val(mID))) + ',' ;
                  + '' + alltrim(str(val(mParent))) + ');'
              if countTmp == COMMIT_COUNT
                cmdTextInsertTmp += textCommitTrans
                sqlite3_exec(db, cmdTextInsertTmp)
                countTmp := 0
                cmdTextInsertTmp := textBeginTrans
              endif
            endif
          next j1
        endif
      next j
      if count > 0
        cmdTextInsert += textCommitTrans
        sqlite3_exec(db, cmdTextInsert)
      endif
      if countTmp > 0
        cmdTextInsertTmp += textCommitTrans
        sqlite3_exec(db, cmdTextInsertTmp)
      endif
      cmdText := "UPDATE implantant SET type = 'U' WHERE EXISTS (SELECT 1 FROM tmp WHERE implantant.id = tmp.parent)"
      if sqlite3_exec(db, cmdText) == SQLITE_OK
        fOut:add_string(hb_eol() + cmdText + ' - Ok')
      else
        OutErr(hb_eol() + cmdText + ' - False')
      endif
      cmdText := "UPDATE implantant SET type = 'L' WHERE NOT EXISTS (SELECT 1 FROM tmp WHERE implantant.id = tmp.parent)"
      if sqlite3_exec(db, cmdText) == SQLITE_OK
        fOut:add_string(hb_eol() + cmdText + ' - Ok')
      else
        OutErr(hb_eol() + cmdText + ' - False')
      endif
      cmdText := 'UPDATE implantant SET type = "O" WHERE rzn = 0'
      if sqlite3_exec(db, cmdText) == SQLITE_OK
        fOut:add_string(hb_eol() + cmdText + ' - Ok')
      else
        OutErr(hb_eol() + cmdText + ' - False')
      endif
      sqlite3_exec(db, 'DROP TABLE IF EXISTS tmp')
      fOut:add_string('��ࠡ�⠭� ' + str(k1) + ' 㧫��.' + hb_eol() )
    // endif
    // sqlite3_clear_bindings(stmt)
    // sqlite3_finalize(stmt)

    // sqlite3_clear_bindings(stmtTMP)
    // sqlite3_finalize(stmtTMP)
  endif
  return nil

// 07.05.22
function make_uslugi_mz(db, source, fOut, fError)
  LOCAL stmt
  local cmdText
  local nfile, nameRef
  local k, j, k1, j1
  local oXmlDoc, oXmlNode, oNode1
  local mID, mS_code, mName, mRel, mDateOut
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  // 1) ID, �������� �����䨪��� , �����᫥���, �᫮��� �ଠ�, ��易⥫쭮� ����;
  // 2) S_CODE, ��� ��㣨, �����, 㭨����� ��� ��㣨 ᮣ��᭮ �ਪ��� �����ࠢ��ࠧ���� ���ᨨ �� 27.12.2011 N 1664� ?�� �⢥ত���� ������������ ����樭᪨� ���?,⥪�⮢� �ଠ�, ��易⥫쭮� ����;
  // 3) NAME, ������ �������� , �����, ⥪�⮢� �ଠ�, ��易⥫쭮� ����;
  // 4) REL, �ਧ��� ���㠫쭮�� , �����᫥���, �᫮��� �ଠ�, ���� ᨬ��� (�᫨ =1 ? ������ ���㠫쭠, �᫨ 0 ? ������ �ࠧ����� � ᮮ⢥��⢨� � ���묨 ��ଠ⨢��-�ࠢ��묨 ��⠬�);
  // 5) DATEOUT, ��� �ࠧ������ , ���, ���, ��᫥ ���ன ������ ������ �ࠧ������ ᮣ��᭮ ���� �ਪ����;
  cmdText := 'CREATE TABLE Mz_services( id INTEGER, s_code TEXT(16), name TEXT(2550), rel INTEGER,  dateout TEXT(10) )'

  nameRef := "1.2.643.5.1.13.13.11.1070.xml"  // ����� �������� ��-�� ���ᨩ
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - ����������� ����樭᪨� ��� (OID)')
  endif

  if sqlite3_exec(db, 'DROP TABLE IF EXISTS Mz_services') == SQLITE_OK
    fOut:add_string('DROP TABLE Mz_services - Ok')
  endif
    
  if sqlite3_exec(db, cmdText) == SQLITE_OK
     fOut:add_string('CREATE TABLE Mz_services - Ok')
  else
     fOut:add_string('CREATE TABLE Mz_services - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty(oXmlDoc:aItems)
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    cmdText := 'INSERT INTO Mz_services ( id, s_code, name, rel, dateout ) VALUES( :id, :s_code, :name, :rel, :dateout )'
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty( stmt )
      fOut:add_string('��ࠡ�⪠ - ' + nfile)
      k := Len(oXmlDoc:aItems[1]:aItems)
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if "ENTRIES" == upper(oXmlNode:title)
          k1 := len(oXmlNode:aItems)
          for j1 := 1 to k1
            oNode1 := oXmlNode:aItems[j1]
            if "ENTRY" == upper(oNode1:title)
              mID := Hb_Translate(mo_read_xml_stroke(oNode1, 'ID', , , 'utf8'), 'UTF8', 'CP866')
              mS_code := Hb_Translate(mo_read_xml_stroke(oNode1, 'S_CODE', , , 'utf8'), 'UTF8', 'CP866')
              mName := Hb_Translate(mo_read_xml_stroke(oNode1, 'NAME', , , 'utf8'), 'UTF8', 'CP866')
              mRel := Hb_Translate(mo_read_xml_stroke(oNode1, 'REL', , , 'utf8'), 'UTF8', 'CP866')
              mDateOut := CToD(Hb_Translate(mo_read_xml_stroke(oNode1, 'DATEOUT', , , 'utf8'), 'UTF8', 'CP866')) //xml2date(mo_read_xml_stroke(oNode1,"DATEOUT",))

              if sqlite3_bind_int(stmt, 1, val(mID)) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 2, mS_code) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 3, mName) == SQLITE_OK .AND. ;
                      sqlite3_bind_int(stmt, 4, val(mRel)) == SQLITE_OK .AND. ;
                      sqlite3_bind_text(stmt, 5, mDateOut) == SQLITE_OK
                if sqlite3_step(stmt) != SQLITE_DONE
                  out_error(fError, TAG_ROW_INVALID, nfile, j)
                endif
              endif
              sqlite3_reset(stmt)
            endif
          next j1
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  return nil
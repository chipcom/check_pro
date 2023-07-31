#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'

// 31.07.23
function make_O0xx(db, source, fOut, fError)

  make_O001(db, source, fOut, fError)
  return nil

// 31.07.23
Function make_O001(db, source, fOut, fError)
  // KOD,     "C",    3,      0
  // NAME11,  "C",  250,      0
  // NAME12", "C",  250,      0
  // ALFA2,   "C",    2,      0
  // ALFA3,   "C",    3,      0
  // DATEBEG, "D",    8,      0
  // DATEEND, "D",    8,      0

  local stmt, stmtTMP
  local cmdText, cmdTextTMP
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mKod, mName11, mName12, mAlfa2, mAlfa3, d1, d2, d1_1
  local mArr

  // cmdText := 'CREATE TABLE o001(kod TEXT(3), name11 TEXT, name12 TEXT, alfa2 TEXT(2), alfa3 TEXT(3), datebeg TEXT(10), dateend TEXT(10))'
  cmdText := 'CREATE TABLE o001(kod TEXT(3), name11 TEXT, name12 TEXT, alfa2 TEXT(2), alfa3 TEXT(3))'

  nameRef := 'O001.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - �����ᨩ᪨� �����䨪��� ��࠭ ��� (OKSM)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS o001') == SQLITE_OK
    fOut:add_string('DROP TABLE o001 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE o001 - Ok' + hb_eol() )
  else
    fOut:add_string('CREATE TABLE o001 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO o001 (kod, name11, name12, alfa2, alfa3, datebeg, dateend) VALUES( :kod, :name11, :name12, :alfa2, :alfa3, :datebeg, :dateend )"
    cmdText := "INSERT INTO o001 (kod, name11, name12, alfa2, alfa3) VALUES( :kod, :name11, :name12, :alfa2, :alfa3 )"
    stmt := sqlite3_prepare(db, cmdText)
    if ! Empty(stmt)
      // out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          d1 := ''
          d1_1 := ''
          d2 := ''
          mKod := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD')
          mArr := hb_ATokens(read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME11'), '^')
          if len(mArr) == 1
            mName11 := mArr[1]
            mName12 := ''
          else
            mName11 := mArr[1]
            mName12 := mArr[2]
          endif
          mAlfa2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'ALFA2')
          mAlfa3 := read_xml_stroke_1251_to_utf8(oXmlNode, 'ALFA3')

          if sqlite3_bind_text(stmt, 1, mKod) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 2, mName11) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 3, mName12) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 4, mAlfa2) == SQLITE_OK .AND. ;
            sqlite3_bind_text(stmt, 5, mAlfa3) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(fError, TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        endif
      next j
    endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  // out_obrabotka_eol()
  return nil

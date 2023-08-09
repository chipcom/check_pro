#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'

// 09.08.23
function make_O0xx(db, source, fOut, fError)

  // make_O001(db, source, fOut, fError)
  make_O002(db, source, fOut, fError)
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

  local stmt
  local cmdText
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
    fOut:add_string(hb_eol() + nameRef + ' - Общероссийский классификатор стран мира (OKSM)' + hb_eol())
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

// 09.08.23
Function make_O002(db, source, fOut, fError)
  // KOD,     "C",    3,      0
  // NAME11,  "C",  250,      0
  // NAME12", "C",  250,      0
  // ALFA2,   "C",    2,      0
  // ALFA3,   "C",    3,      0
  // DATEBEG, "D",    8,      0
  // DATEEND, "D",    8,      0

  local stmt
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mTer, mName1, mKod1, mKod2, mKod3, mRazdel, mCentrum
  local mOKATO, mFl_zagol, mTip, mFl_vibor, mSelo, valKod1

  cmdText := 'CREATE TABLE _okator(okato TEXT(2), name TEXT(72))'

  nameRef := 'O002.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Общероссийский классификатор административно-территориального деления (OKATO)' + hb_eol())
  endif

  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okator') == SQLITE_OK
    fOut:add_string('DROP TABLE _okator - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okator - Ok' + hb_eol() )
  else
    fOut:add_string('CREATE TABLE _okator - False' + hb_eol() )
    return nil
  endif

  cmdText := 'CREATE TABLE _okatoo (okato TEXT(5), name TEXT(72), fl_vibor INTEGER, fl_zagol INTEGER, tip INTEGER, selo INTEGER)'
  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okatoo') == SQLITE_OK
    fOut:add_string('DROP TABLE _okatoo - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okatoo - Ok' + hb_eol() )
  else
    fOut:add_string('CREATE TABLE _okatoo - False' + hb_eol() )
    return nil
  endif

  cmdText := 'CREATE TABLE _okatoo8 (okato TEXT(5), name TEXT(72), fl_vibor INTEGER, fl_zagol INTEGER, tip INTEGER, selo INTEGER)'
  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okatoo8') == SQLITE_OK
    fOut:add_string('DROP TABLE _okatoo8 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okatoo8 - Ok' + hb_eol() )
  else
    fOut:add_string('CREATE TABLE _okatoo8 - False' + hb_eol() )
    return nil
  endif


  cmdText := 'CREATE TABLE _okatos (okato TEXT(11), name TEXT(72), fl_vibor INTEGER, fl_zagol INTEGER, tip INTEGER, selo INTEGER)'

  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okatos') == SQLITE_OK
    fOut:add_string('DROP TABLE _okatos - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okatos - Ok' + hb_eol() )
  else
    fOut:add_string('CREATE TABLE _okatos - False' + hb_eol() )
    return nil
  endif

  cmdText := 'CREATE TABLE _okatos8 (okato TEXT(11), name TEXT(72), fl_vibor INTEGER, fl_zagol INTEGER, tip INTEGER, selo INTEGER)'
  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okatos8') == SQLITE_OK
    fOut:add_string('DROP TABLE _okatos8 - Ok' + hb_eol())
  endif

  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okatos8 - Ok' + hb_eol() )
  else
    fOut:add_string('CREATE TABLE _okatos8 - False' + hb_eol() )
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    // cmdText := "INSERT INTO _okator (okato, name) VALUES( :okato, :name )"
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty(stmt)
      // out_obrabotka(nfile)
      k := Len( oXmlDoc:aItems[1]:aItems )
      for j := 1 to k
        oXmlNode := oXmlDoc:aItems[1]:aItems[j]
        if 'ZAP' == upper(oXmlNode:title)
          mTer := read_xml_stroke_1251_to_utf8(oXmlNode, 'TER')
          mKod1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD1')
          mKod2 := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD2')
          mKod3 := read_xml_stroke_1251_to_utf8(oXmlNode, 'KOD3')
          mRazdel := read_xml_stroke_1251_to_utf8(oXmlNode, 'RAZDEL')
          // mCentrum := read_xml_stroke_1251_to_utf8(oXmlNode, 'CENTRUM')
          mName1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME1')

          if mTer != '00' .and. mKod1 == '000' .and. mKod2 == '000' .and. mKod3 == '000' .and. ;
                      alltrim(mRazdel) == '1'
            cmdText := "INSERT INTO _okator (okato, name) VALUES( :okato, :name )"
            stmt := sqlite3_prepare(db, cmdText)
            if sqlite3_bind_text(stmt, 1, mTer) == SQLITE_OK .AND. ;
                sqlite3_bind_text(stmt, 2, mName1) == SQLITE_OK
              if sqlite3_step(stmt) != SQLITE_DONE
                out_error(fError, TAG_ROW_INVALID, nfile, j)
              endif
            endif
            sqlite3_reset(stmt)
          endif
          if mKod1 != '000' .and. mKod2 == '000' .and. mKod3 == '000' .and. ;
                alltrim(mRazdel) == '1'
            cmdText := "INSERT INTO _okatoo (okato, name, fl_vibor, fl_zagol, tip, selo) VALUES( :okato, :name, :fl_vibor, :fl_zagol, :tip, :selo )"
            stmt := sqlite3_prepare(db, cmdText)

            valKod1 := val(mKod1)
            // rajon->name   := padr(charrem("/",okato->name1),72)
            if eq_any(alltrim(mKod1), '110', '120', '130', '140', '150', '170', '200', ;
                                '400' , '500', '550')
              // rajon->fl_zagol := 1
              mFl_zagol := 1
            endif
            if valKod1 < 200     // округа
              mTip := 1
            elseif valKod1 < 400 // районы
              mTip := 2
            elseif valKod1 < 500 // города пос гор типа
              mTip := 3
              // ВЫЯСНЯЕМ ВОЗМОЖНОСТЬ ВЫБОРА
              // t := mKod1
              // select OKATO
              // skip
              // if okato->kod1 == t .and. val(okato->kod2) > 500
              //   //у города есть подчинённые нас. пункты
              //   rajon->fl_vibor := 2
              // elseif okato->kod1 != t
              //   //выбор только города
              //   rajon->fl_vibor := 1
              // endif
              // select OKATO
              // skip -1
            elseif valKod1 < 500 // города пос гор типа
              mTip := 3
              // ВЫЯСНЯЕМ ВОЗМОЖНОСТЬ ВЫБОРА
              // t := okato->kod1
              // select OKATO
              // skip
              // if okato->kod1 == t .and. val(okato->kod2) > 500
              //   //у города есть подчинённые нас. пункты
              //   rajon->fl_vibor := 2
              // elseif okato->kod1 != t
              //   //выбор только города
              //   rajon->fl_vibor := 1
              // endif
              // select OKATO
              // skip -1
            else                          //федеральные города
              mTip := 4
            endif
            if valKod1 < 200     // округа
              mSelo := 0
            elseif valKod1 < 400 // районы
              mSelo := 0
            elseif valKod1 < 500 // пос гор типа
              mSelo := 1
            else                          // федеральные города
              mSelo := 1
            endif
          endif

          mOKATO  := mTer + mKod1
          mFl_vibor := 0
if ValType(mOKATO) != 'C' .or. ValType(mName1) != 'C'
  altd()
endif
          if sqlite3_bind_text(stmt, 1, mOKATO) == SQLITE_OK .AND. ;
                sqlite3_bind_text(stmt, 2, mName1) == SQLITE_OK .AND. ;
                sqlite3_bind_int(stmt, 3, mFl_vibor) == SQLITE_OK .AND. ;
                sqlite3_bind_int(stmt, 4, mFl_zagol) == SQLITE_OK .AND. ;
                sqlite3_bind_int(stmt, 5, mTip) == SQLITE_OK .AND. ;
                sqlite3_bind_int(stmt, 6, mSelo) == SQLITE_OK
            if sqlite3_step(stmt) != SQLITE_DONE
              out_error(fError, TAG_ROW_INVALID, nfile, j)
            endif
          endif
          sqlite3_reset(stmt)
        
       
        endif
      next j
    // endif
    sqlite3_clear_bindings(stmt)
    sqlite3_finalize(stmt)
  endif
  // out_obrabotka_eol()
  return nil

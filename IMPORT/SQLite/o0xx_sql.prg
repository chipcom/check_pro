#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'
#define COMMIT_COUNT  500
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
  local stmt
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode, oNode1, oNode2
  local mTer, mName1, mKod1, mKod2, mKod3, mRazdel
  local mOKATO, mFl_zagol := 0, mTip := 0, mFl_vibor := 0, mSelo := 0
  local valKod1 := 0, valKod2 := 0
  local mCentrum, aTemp
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local count := 0, cmdSeloText := textBeginTrans
  local count18 := 0, cmdSelo18 := textBeginTrans
  local countRegion := 0, cmdRegionText := textBeginTrans
  local countCity := 0, cmdCityText := textBeginTrans
  local countCity18 := 0, cmdCity18 := textBeginTrans

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
          mName1 := read_xml_stroke_1251_to_utf8(oXmlNode, 'NAME1')
          mCentrum := read_xml_stroke_1251_to_utf8(oXmlNode, 'CENTRUM')
          valKod1 := val(mKod1)
          valKod2 := val(mKod2)

          if mTer != '00' .and. mKod1 == '000' .and. mKod2 == '000' .and. mKod3 == '000' .and. ;
                      alltrim(mRazdel) == '1'
            countRegion++
            cmdRegionText += 'INSERT INTO _okator (okato, name) VALUES(' ;
                    + "'" + mTer +"'," ;
                    +  "'" + mName1 + "');"
            if countRegion == COMMIT_COUNT
              cmdRegionText += "COMMIT;"
              sqlite3_exec(db, cmdRegionText)
              countRegion := 0
              cmdRegionText := textBeginTrans
            endif
          endif

          if mKod1 != '000' .and. mKod2 == '000' .and. mKod3 == '000' .and. ;
                alltrim(mRazdel) == '1'
            if eq_any(alltrim(mKod1), '110', '120', '130', '140', '150', '170', '200', ;
                                '400' , '500', '550')
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

            mOKATO  := mTer + mKod1
            mFl_vibor := 0
  
            countCity++
            cmdCityText += 'INSERT INTO _okatoo (okato, name, fl_vibor, fl_zagol, tip, selo) VALUES(' ;
                  + "'" + mOKATO + "'," ;
                  +  "'" + mName1 + "'," ;
                  + str(mFl_vibor, 1) + "," ;
                  + str(mFl_zagol, 1) + "," ;
                  + str(mTip, 1) + "," ;
                  + str(mSelo, 1) + ");"
            if count == COMMIT_COUNT
              cmdCityText += "COMMIT;"
              sqlite3_exec(db, cmdCityText)
              countCity := 0
              cmdCityText := textBeginTrans
            endif

            if mTer == '18' // для Волгоградской области
              countCity18++
              cmdCity18 += 'INSERT INTO _okatoo8 (okato, name, fl_vibor, fl_zagol, tip, selo) VALUES(' ;
                  + "'" + mOKATO +"'," ;
                  +  "'" + mName1 + "'," ;
                  + str(mFl_vibor, 1) + "," ;
                  + str(mFl_zagol, 1) + "," ;
                  + str(mTip, 1) + "," ;
                  + str(mSelo, 1) + ");"
              if countCity18 == COMMIT_COUNT
                cmdCity18 += "COMMIT;"
                sqlite3_exec(db, cmdCity18)
                countCity18 := 0
                cmdCity18 := textBeginTrans
              endif
            endif
            aTemp := {mTer, mKod1, mKod2, mKod3, mRazdel, mName1}
          endif

          if mKod2 != '000' .and. mKod1 != '000'
            if mKod3 != '000' .or. (mKod3 == '000' .and. alltrim(mRazdel) == '1' ;
               .and. valKod2 < 600) .or. (mKod3 == '000' .and. alltrim(mRazdel) == '1' ;
               .and. valKod2 == 800)

              mOKATO  := mTer + mKod1 + mKod2 + mKod3
              if valKod2 == 800
                mName1 := padr(atrepl('Сельсоветы', charrem('/', mName1), 'Населённые пункты'), 60)
              else
                mName1 := alltrim(charrem('/', mName1)) + iif(len(alltrim(mCentrum)) > 2, '/' + alltrim(mCentrum), '')
              endif
              mFl_vibor := 1
              if eq_any(mKod2, '360', '500', '550', '600', '800')
                 mFl_zagol := 1
              endif
              if val(mKod1) < 200     // округа
                mTip := 1
              elseif val(mKod1) < 400 // районы
                mTip := 2
              elseif val(mKod1) < 500 // города пос гор типа
                mTip := 3
              else                          // федеральные города
                mTip := 4
              endif
              if val(mKod1) < 200     // округа
                mSelo := 0
              elseif val(mKod1) < 400 // районы
                mSelo := 0
              elseif val(mKod1) < 500 // города пос гор типа
                mSelo := 1
              else                          // федеральные города
                mSelo := 1
              endif
              if mSelo == 0  //selo
                if valKod2 > 500 .and. valKod2 < 600
                  mSelo := 1
                endif
              endif
              count++
              cmdSeloText += 'INSERT INTO _okatos (okato, name, fl_vibor, fl_zagol, tip, selo) VALUES(' ;
                    + "'" + mOKATO +"'," ;
                    +  "'" + mName1 + "'," ;
                    + str(mFl_vibor, 1) + "," ;
                    + str(mFl_zagol, 1) + "," ;
                    + str(mTip, 1) + "," ;
                    + str(mSelo, 1) + ");"
              if count == COMMIT_COUNT
                cmdSeloText += "COMMIT;"
                sqlite3_exec(db, cmdSeloText)
                count := 0
                cmdSeloText := textBeginTrans
              endif

              if mTer == '18' // для Волгоградской области
                count18++
                cmdSelo18 += 'INSERT INTO _okatos8 (okato, name, fl_vibor, fl_zagol, tip, selo) VALUES(' ;
                    + "'" + mOKATO +"'," ;
                    +  "'" + mName1 + "'," ;
                    + str(mFl_vibor, 1) + "," ;
                    + str(mFl_zagol, 1) + "," ;
                    + str(mTip, 1) + "," ;
                    + str(mSelo, 1) + ");"
                if count18 == COMMIT_COUNT
                  cmdSelo18 += "COMMIT;"
                  sqlite3_exec(db, cmdSelo18)
                  count18 := 0
                  cmdSelo18 := textBeginTrans
                endif
              endif
            endif
          endif
        endif
      next j
      if countRegion > 0
        cmdRegionText += "COMMIT;"
        sqlite3_exec(db, cmdRegionText)
      endif
      if countCity > 0
        cmdCityText += "COMMIT;"
        sqlite3_exec(db, cmdCityText)
      endif
      if countCity18 > 0
        cmdCity18 += "COMMIT;"
        sqlite3_exec(db, cmdCity18)
      endif
      if count > 0
        cmdSeloText += "COMMIT;"
        sqlite3_exec(db, cmdSeloText)
      endif
      if count18 > 0
        cmdSelo18 += "COMMIT;"
        sqlite3_exec(db, cmdSelo18)
      endif

  endif
  // out_obrabotka_eol()
  return nil

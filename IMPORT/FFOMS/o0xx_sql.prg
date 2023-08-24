#include 'function.ch'
#include '.\dict_error.ch'

#require 'hbsqlit3'
#define COMMIT_COUNT  500

// 11.08.23
function make_O0xx(db, source, fOut, fError)

  // make_O001(db, source, fOut, fError)
  // make_O002(db, source, fOut, fError)
  make_O002_dbf(db, source, fOut, fError, 'd:\_mo\chip\work_check\')
  return nil

// 11.08.23
Function make_O001(db, source, fOut, fError)
  // KOD,     "C",    3,      0
  // NAME11,  "C",  250,      0
  // NAME12", "C",  250,      0
  // ALFA2,   "C",    2,      0
  // ALFA3,   "C",    3,      0
  // DATEBEG, "D",    8,      0
  // DATEEND, "D",    8,      0

  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mKod, mName11, mName12, mAlfa2, mAlfa3
  local mArr
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  cmdText := 'CREATE TABLE o001(kod TEXT(3), name11 TEXT, name12 TEXT, alfa2 TEXT(2), alfa3 TEXT(3))'

  nameRef := 'O001.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Общероссийский классификатор стран мира (OKSM)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS o001') == SQLITE_OK
    fOut:add_string('DROP TABLE o001 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE o001 - Ok')
  else
    fOut:add_string('CREATE TABLE o001 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile)
    k := Len( oXmlDoc:aItems[1]:aItems )
    for j := 1 to k
      oXmlNode := oXmlDoc:aItems[1]:aItems[j]
      if 'ZAP' == upper(oXmlNode:title)
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

        count++
        cmdTextInsert += 'INSERT INTO o001 (kod, name11, name12, alfa2, alfa3) VALUES(' ;
            + "'" + mKod + "'," ;
            + "'" + mName11 + "'," ;
            + "'" + mName12 + "'," ;
            + "'" + mAlfa2 + "'," ;
            + "'" + mAlfa3 + "');"
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
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 11.08.23
Function make_O002(db, source, fOut, fError)
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mTer, mName1, mKod1, mKod2, mKod3, mRazdel
  local mOKATO, mFl_zagol := 0, mTip := 0, mFl_vibor := 0, mSelo := 0
  local valKod1 := 0, valKod2 := 0
  local mCentrum, aTemp
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
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
    fOut:add_string(hb_eol() + nameRef + ' - Общероссийский классификатор административно-территориального деления (OKATO)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okator') == SQLITE_OK
    fOut:add_string('DROP TABLE _okator - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okator - Ok')
  else
    fOut:add_string('CREATE TABLE _okator - False')
    return nil
  endif

  cmdText := 'CREATE TABLE _okatoo (okato TEXT(5), name TEXT(72), fl_vibor INTEGER, fl_zagol INTEGER, tip INTEGER, selo INTEGER)'
  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okatoo') == SQLITE_OK
    fOut:add_string('DROP TABLE _okatoo - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okatoo - Ok')
  else
    fOut:add_string('CREATE TABLE _okatoo - False')
    return nil
  endif

  cmdText := 'CREATE TABLE _okatoo8 (okato TEXT(5), name TEXT(72), fl_vibor INTEGER, fl_zagol INTEGER, tip INTEGER, selo INTEGER)'
  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okatoo8') == SQLITE_OK
    fOut:add_string('DROP TABLE _okatoo8 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okatoo8 - Ok')
  else
    fOut:add_string('CREATE TABLE _okatoo8 - False')
    return nil
  endif

  cmdText := 'CREATE TABLE _okatos (okato TEXT(11), name TEXT(72), fl_vibor INTEGER, fl_zagol INTEGER, tip INTEGER, selo INTEGER)'
  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okatos') == SQLITE_OK
    fOut:add_string('DROP TABLE _okatos - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okatos - Ok')
  else
    fOut:add_string('CREATE TABLE _okatos - False')
    return nil
  endif

  cmdText := 'CREATE TABLE _okatos8 (okato TEXT(11), name TEXT(72), fl_vibor INTEGER, fl_zagol INTEGER, tip INTEGER, selo INTEGER)'
  if sqlite3_exec(db, 'DROP TABLE if EXISTS _okatos8') == SQLITE_OK
    fOut:add_string('DROP TABLE _okatos8 - Ok')
  endif
  if sqlite3_exec(db, cmdText) == SQLITE_OK
    fOut:add_string('CREATE TABLE _okatos8 - Ok')
  else
    fOut:add_string('CREATE TABLE _okatos8 - False')
    return nil
  endif

  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile + hb_eol())
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
            cmdRegionText += textCommitTrans
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
          if countCity == COMMIT_COUNT
            cmdCityText += textCommitTrans
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
              cmdCity18 += textCommitTrans
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
            else                          // федеральные города                mSelo := 1
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
              cmdSeloText += textCommitTrans
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
                cmdSelo18 += textCommitTrans
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
      cmdRegionText += textCommitTrans
      sqlite3_exec(db, cmdRegionText)
    endif
    if countCity > 0
      cmdCityText += textCommitTrans
      sqlite3_exec(db, cmdCityText)
    endif
    if countCity18 > 0
      cmdCity18 += textCommitTrans
      sqlite3_exec(db, cmdCity18)
    endif
    if count > 0
      cmdSeloText += textCommitTrans
      sqlite3_exec(db, cmdSeloText)
    endif
    if count18 > 0
      cmdSelo18 += textCommitTrans
      sqlite3_exec(db, cmdSelo18)
    endif
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 24.08.23
Function make_O002_dbf(db, source, fOut, fError, destination)
  Local _mo_okato := { ;
    {'TER',      'C',      2,      0}, ;
    {'KOD1',     'C',      3,      0}, ;
    {'KOD2',     'C',      3,      0}, ;
    {'KOD3',     'C',      3,      0}, ;
    {'RAZDEL',   'C',      1,      0}, ;
    {'NAME1',    'C',    122,      0}, ;
    {'CENTRUM',  'C',    114,      0}, ;
    {'N8',       'C',    103,      0}, ;
    {'N9',       'C',     27,      0}, ;
    {'N10',      'C',     27,      0}, ;
    {'N11',      'C',     27,      0}, ;
    {'N12',      'C',     24,      0}, ;
    {'N13',      'C',     28,      0}, ;
    {'N14',      'C',     21,      0}, ;
    {'N15',      'C',      3,      0}, ;
    {'N16',      'C',      1,      0}, ;
    {'N17',      'C',     10,      0}, ;
    {'N18',      'C',     10,      0} ;
  }
  local cmdText
  local k, j
  local nfile, nameRef
  local oXmlDoc, oXmlNode
  local mTer, mName1, mKod1, mKod2, mKod3, mRazdel
  local mOKATO, mFl_zagol := 0, mTip := 0, mFl_vibor := 0, mSelo := 0
  local valKod1 := 0, valKod2 := 0
  local mCentrum, aTemp
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdSeloText := textBeginTrans
  local count18 := 0, cmdSelo18 := textBeginTrans
  local countRegion := 0, cmdRegionText := textBeginTrans
  local countCity := 0, cmdCityText := textBeginTrans
  local countCity18 := 0, cmdCity18 := textBeginTrans
  local nameFile := 'okato'

  // cmdText := 'CREATE TABLE _okator(okato TEXT(2), name TEXT(72))'

  nameRef := 'O002.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Общероссийский классификатор административно-территориального деления (OKATO)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

  dbcreate(destination + nameFile, _mo_okato)
  use (destination + nameFile) new alias OKATO


  oXmlDoc := HXMLDoc():Read(nfile)
  if Empty( oXmlDoc:aItems )
    out_error(fError, FILE_READ_ERROR, nfile)
    return nil
  else
    fOut:add_string('Обработка - ' + nfile + hb_eol())
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
        if mTer == '00' .and. mKod1 == '000' .and. mKod2 == '000' .and. mKod3 == '000'
          loop
        endif
        
        OKATO->(dbappend())
        if len(alltrim(mTer)) < 2
          OKATO->TER := padl(alltrim(mTer), 2, '0')
        else
          OKATO->TER   := mTer
        endif
        OKATO->KOD1   := iif(alltrim(mKod1) == '0', '000', mKod1)
        OKATO->KOD2    := iif(alltrim(mKod2) == '0', '000', mKod2)
        OKATO->KOD3    := iif(alltrim(mKod3) == '0', '000', mKod3)

        OKATO->RAZDEL    := mRazdel
        OKATO->NAME1 := mName1
        OKATO->CENTRUM := mCentrum
      endif
    next j
    fOut:add_string('Обработано ' + str(j) + ' узлов.' + hb_eol() )
  endif
  OKATO->(dbCloseArea())
  return nil

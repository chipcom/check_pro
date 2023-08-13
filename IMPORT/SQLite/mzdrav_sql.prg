/// Справочники Министерства здравоохранения РФ

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

  // make_uslugi_mz(db, source, fOut, fError) // не используем (для будующего)

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

  // 1) ID, Код , Целочисленный, уникальный идентификатор, возможные значения ? целые числа от 1 до 6;
  // 2) NAME, Полное название, Строчный, обязательное поле, текстовый формат;
  // 3) SYN, Синонимы, Строчный, синонимы терминов справочника, текстовый формат;
  // 4) SCTID, Код SNOMED CT , Строчный, соответствующий код номенклатуры;
  // 5) SORT, Сортировка , Целочисленный, приведение данных к порядковой шкале для упорядочивания терминов
  //    справочника от более легкой к более тяжелой степени тяжести состояний, целое число от 1 до 7;
  cmdText := 'CREATE TABLE Severity( id INTEGER, name TEXT(40), syn TEXT(50), sctid INTEGER, sort INTEGER )'
  
  nameRef := '1.2.643.5.1.13.13.11.1006.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Степень тяжести состояния пациента (OID)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

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
    fOut:add_string('Обработка - ' + nfile)
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
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
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

  // 1) ID, Уникальный идентификатор, Целочисленный, Уникальный идентификатор единицы измерения лабораторного теста;
  // 2) FULLNAME, Полное наименование, Строчный;
  // 3) SHORTNAME, Краткое наименование, Строчный;
  // 4) PRINTNAME, Наименование для печати, Строчный;
  // 5) MEASUREMENT, Размерность, Строчный;
  // 6) UCUM, Код UCUM, Строчный;
  // 7) COEFFICIENT, Коэффициент пересчета, Строчный, Коэффициент пересчета в рамках одной размерности.;
  // 8) FORMULA, Формула пересчета, Строчный, В настоящей версии справочника не используется.;
  // 9) CONVERSION_ID, Код единицы измерения для пересчета, Целочисленный, Код единицы измерения, в которую осуществляется пересчет.;
  // 10) CONVERSION_NAME, Единица измерения для пересчета, Строчный, Краткое наименование единицы измерения, в которую осуществляется пересчет.;
  // 11) OKEI_CODE, Код ОКЕИ, Строчный, Соответствующий код Общероссийского классификатора единиц измерений.;
  // // 12) NSI_CODE_EEC, Код справочника ЕАЭК, Строчный, необязательное поле ? код справочника реестра НСИ ЕАЭК;
  // // 13) NSI_ELEMENT_CODE_EEC, Код элемента справочника ЕАЭК, Строчный, необязательное поле ? код элемента справочника реестра НСИ ЕАЭК;
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
    fOut:add_string(hb_eol() + nameRef + ' - Единицы измерения (OID)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

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
    fOut:add_string('Обработка - ' + nfile)
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
    fOut:add_string('Обработано ' + str(k1) + ' узлов.' + hb_eol() )
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

  // 1) ID, Код, Целочисленный, уникальный идентификатор, обязательное поле, целое число;
  // 2) NAME_RUS, Путь введения на русском языке, Строчный, наименование пути введения лекарственных средств на русском языке, обязательное поле, текстовый формат;
  // 3) NAME_ENG, Путь введения на английском языке, Строчный, наименование пути введения лекарственных средств на английском языке, обязательное поле, текстовый формат;
  // 4) PARENT, Родительский узел, Целочисленный, родительский узел иерархического справочника, целое число;
  // // 5) NSI_CODE_EEC, Код справочника ЕАЭК, Строчный, необязательное поле ? код справочника реестра НСИ ЕАЭК;
  // // 6) NSI_ELEMENT_CODE_EEC, Код элемента справочника ЕАЭК, Строчный, необязательное поле ? код элемента справочника реестра НСИ ЕАЭК;
  // ++) TYPE, Тип записи, символьный: 'O' корневой узел, 'U' узел, 'L' конечный элемент
  cmdText := 'CREATE TABLE MethIntro(id INTEGER, name_rus TEXT(30), name_eng TEXT(30), parent INTEGER, type TEXT(1))'
    
  nameRef := "1.2.643.5.1.13.13.11.1468.xml"
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + " - Пути введения лекарственных препаратов, в том числе для льготного обеспечения граждан лекарственными средствами (MethIntro)" + hb_eol())
  endif

  stat_msg('Обработка файла: ' + nfile)  

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
    // временная таблица для дальнейшего использования
    cmdTextTMP := 'CREATE TABLE tmp( id INTEGER, parent INTEGER)'
    sqlite3_exec(db, 'DROP TABLE IF EXISTS tmp')
    sqlite3_exec(db, cmdTextTMP)
    
    fOut:add_string('Обработка - ' + nfile)
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
    fOut:add_string('Обработано ' + str(k1) + ' узлов.' + hb_eol() )
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

  // 1)ID, Код , уникальный идентификатор записи;
  // 2)RZN, Росздравнадзор , код изделия согласно Номенклатурному классификатору Росздравнадзора;
  // 3)PARENT, Код родительского элемента;
  // 4)NAME, Наименование , наименование вида изделия;
  // 5)ACTUAL, Актуальность, Логический;
  // 6)EXISTENCE_NPA, Признак наличия НПА, Логический
  // // 5)LOCALIZATION, Локализация , анатомическая область, к которой относится локализация и/или действие изделия;
  // // 6)MATERIAL, Материал , тип материала, из которого изготовлено изделие;
  // // 7)METAL, Металл , признак наличия металла в изделии;
  // // 8)SCTID, Код SNOMED CT , уникальный код по номенклатуре клинических терминов SNOMED CT;
  // // 9)ORDER, Порядок сортировки ;
  // ++) TYPE, Тип записи, символьный: 'O' корневой узел, 'U' узел, 'L' конечный элемент
  // cmdText := 'CREATE TABLE implantant( id INTEGER, rzn INTEGER, parent INTEGER, name TEXT(120), local TEXT(80), material TEXT(20), _order INTEGER, type TEXT(1) )'
  cmdText := 'CREATE TABLE implantant(id INTEGER, rzn INTEGER, parent INTEGER, name TEXT(120), type TEXT(1))'
    
  nameRef := '1.2.643.5.1.13.13.11.1079.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Виды медицинских изделий, имплантируемых в организм человека, и иных устройств для пациентов с ограниченными возможностями (OID)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

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
    // временная таблица для дальнейшего использования
    cmdTextTMP := 'CREATE TABLE tmp(id INTEGER, parent INTEGER)'
    sqlite3_exec(db, 'DROP TABLE IF EXISTS tmp')
    sqlite3_exec(db, cmdTextTMP)

    // cmdTextTMP := 'INSERT INTO tmp(id, parent) VALUES (:id, :parent)'
    // stmtTMP := sqlite3_prepare(db, cmdTextTMP)
    // cmdText := 'INSERT INTO implantant (id, rzn, parent, name, type) VALUES(:id, :rzn, :parent, :name, :type)'
    // stmt := sqlite3_prepare(db, cmdText)
    // if ! Empty( stmt )
      fOut:add_string('Обработка - ' + nfile)
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
      fOut:add_string('Обработано ' + str(k1) + ' узлов.' + hb_eol() )
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

  // 1) ID, Уникальный идентификатор , Целочисленный, числовой формат, обязательное поле;
  // 2) S_CODE, Код услуги, Строчный, уникальный код услуги согласно Приказу Минздравсоцразвития России от 27.12.2011 N 1664н ?Об утверждении номенклатуры медицинских услуг?,текстовый формат, обязательное поле;
  // 3) NAME, Полное название , Строчный, текстовый формат, обязательное поле;
  // 4) REL, Признак актуальности , Целочисленный, числовой формат, один символ (если =1 ? запись актуальна, если 0 ? запись упразднена в соответствии с новыми нормативно-правовыми актами);
  // 5) DATEOUT, Дата упразднения , Дата, дата, после которой данная запись упраздняется согласно новым приказам;
  cmdText := 'CREATE TABLE Mz_services( id INTEGER, s_code TEXT(16), name TEXT(2550), rel INTEGER,  dateout TEXT(10) )'

  nameRef := "1.2.643.5.1.13.13.11.1070.xml"  // может меняться из-за версий
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Номенклатура медицинских услуг (OID)')
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
      fOut:add_string('Обработка - ' + nfile)
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
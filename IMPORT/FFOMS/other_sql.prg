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
    fOut:add_string(hb_eol() + nameRef + ' - Справочник T007')
  endif
  
  fOut:add_string(hb_eol() + 'Классификатор T007')

  stat_msg('Обработка файла: ' + nfile)  

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
  fOut:add_string('Обработано ' + str(j) + ' узлов.' + hb_eol() )
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

  // CODE, Целочисленный(3),	Код ошибки
  // NAME, Строчный(250),	Наименование ошибки
  // NAME_F, Строчный(250), Дополнительная информация об ошибке
  // DATEBEG, Строчный(10),	Дата начала действия записи
  // DATEEND, Строчный(10),	Дата окончания действия записи
  // cmdText := 'CREATE TABLE isderr( code INTEGER, name TEXT(250), name_f TEXT(250))'
  cmdText := 'CREATE TABLE isderr( code INTEGER, name TEXT(250))'

  nameRef := 'ISDErr.xml'
  nfile := source + nameRef
  if ! hb_vfExists(nfile)
    out_error(fError, FILE_NOT_EXIST, nfile)
    return nil
  else
    fOut:add_string(hb_eol() + nameRef + ' - Справочник ошибок ИСОМПД (Т012)')
  endif

  stat_msg('Обработка файла: ' + nfile)  

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
    fOut:add_string('Обработка - ' + nfile)
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
    fOut:add_string('Обработано ' + str(k) + ' узлов.' + hb_eol() )
  endif
  return nil

// 13.08.23
function dlo_lgota(db, source, fOut, fError)
  // Классификатор кодов льгот по ДЛО
  //  1 - NAME(C)  2 - KOD(C)

  local cmdText
  local k
  local mKod, mName
  local mArr := {}
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  aadd(mArr, {'000 --- без льготы ---', '   '})
  aadd(mArr, {'010 Инвалиды войны', '010'})
  aadd(mArr, {'011 Участники Великой Отечественной войны, ставшие инвалидами', '011'})
  aadd(mArr, {'012 Военнослужащие органов внутренних дел, Государственной противопожарной службы, учреждений и органов уголовно-исполнительной системы, ставших инвалидами вследствие ранения, контузии или увечья, полученных при исполнении обязанностей военной службы', '012'})
  aadd(mArr, {'020 Участники Великой Отечественной войны', '020'})
  aadd(mArr, {'030 Ветераны боевых действий', '030'})
  aadd(mArr, {'040 Военнослужащие, проходившие военную службу в воинских частях, не входивших в состав действующей армии, в период с 22 июня 1941 года по 3 сентября 1945 года не менее шести месяцев, военнослужащие, награжденные орденами или медалями СССР', '040'})
  aadd(mArr, {'050 Лица, награжденные знаком "Жителю блокадного Ленинграда"', '050'})
  aadd(mArr, {'060 Члены семей погибших (умерших) инвалидов войны, участников Великой Отечественной войны и ветеранов боевых действий', '060'})
  aadd(mArr, {'061 Члены семей погибших в Великой Отечественной войне лиц из числа личного состава групп самозащиты объектовых и аварийных команд местной противовоздушной обороны, а также члены семей погибших работников госпиталей и больниц города Ленинграда', '061'})
  aadd(mArr, {'062 Члены семей военнослужащих органов внутренних дел, Государственной противопожарной службы, учреждений и органов уголовно-исполнительной системы и органов государственной безопасности, погибших при исполнении обязанностей военной службы', '062'})
  aadd(mArr, {'063 Члены семей военнослужащих, погибших в плену, признанных в установленном порядке пропавшими без вести в районах боевых действий', '063'})
  aadd(mArr, {'081 Инвалиды I степени', '081'})
  aadd(mArr, {'082 Инвалиды II степени', '082'})
  aadd(mArr, {'083 Инвалиды III степени', '083'})
  aadd(mArr, {'084 Дети-инвалиды', '084'})
  aadd(mArr, {'085 Инвалиды, не имеющие степени ограничения способности к трудовой деятельности', '085'})
  aadd(mArr, {'091 Граждане, получившие или перенесшие лучевую болезнь и другие заболевания, связанные с радиационным воздействием вследствие чернобыльской катастрофы или с работами по ликвидации последствий катастрофы на Чернобыльской АЭС', '091'})
  aadd(mArr, {'092 Инвалиды вследствие чернобыльской катастрофы', '092'})
  aadd(mArr, {'093 Граждане, принимавшие в 1986-1987 годах участие в работах по ликвидации последствий чернобыльской катастрофы', '093'})
  aadd(mArr, {'094 Граждане, принимавшие участие в 1988-90гг. участие в работах по ликвидации последствий чернобыльской катастрофы', '094'})
  aadd(mArr, {'095 Граждане, постоянно проживающие (работающие) на территории зоны проживания с правом на отселение', '095'})
  aadd(mArr, {'096 Граждане, постоянно проживающие (работающие) на территории зоны проживания с льготным социально-экономическим статусом', '096'})
  aadd(mArr, {'097 Граждане, постоянно проживающие (работающие) в зоне отселения до их переселения в другие районы', '097'})
  aadd(mArr, {'098 Граждане, эвакуированные (в том числе выехавшие добровольно) в 1986 году из зоны отчуждения', '098'})
  aadd(mArr, {'099 Дети и подростки в возрасте до 18 лет, проживающие в зоне отселения и зоне проживания с правом на отселение, эвакуированные и переселенные из зон отчуждения, отселения, проживания с правом на отселение', '099'})
  aadd(mArr, {'100 Дети и подростки в возрасте до 18 лет, постоянно проживающие в зоне с льготным социально-экономическим статусом', '100'})
  aadd(mArr, {'101 Дети и подростки, страдающие болезнями вследствие чернобыльской катастрофы, ставшие инвалидами', '101'})
  aadd(mArr, {'102 Дети и подростки, страдающие болезнями вследствие чернобыльской катастрофы', '102'})
  aadd(mArr, {'111 Граждане, получившие суммарную (накопительную) эффективную дозу облучения, превышающую 25 сЗв (бэр)', '111'})
  aadd(mArr, {'112 Граждане, получившие суммарную (накопительную) эффективную дозу облучения более 5 сЗв (бэр), но не превышающую 25 сЗв (бэр)', '112'})
  aadd(mArr, {'113 Дети в возрасте до 18 лет первого и второго поколения граждан, получившие суммарную (накопительную) эффективную дозу облучения более 5 сЗв (бэр), страдающих заболеваниями вследствие радиационного воздействия на одного из родителей', '113'})
  aadd(mArr, {'120 Лица, работавшие в период Великой Отечественной войны на объектах противовоздушной обороны, на строительстве оборонительных сооружений, военно-морских баз, аэродромов и других военных объектов', '120'})
  aadd(mArr, {'121 Граждане, получившие лучевую болезнь, обусловленную воздействием радиации вследствие аварии в 1957 году на производственном объединении "Маяк" и сбросов радиоактивных отходов в реку Теча', '121'})
  aadd(mArr, {'122 Граждане, ставшие инвалидами в результате воздействия радиации вследствие аварии в 1957 году на производственном объединении "Маяк" и сбросов радиоактивных отходов в реку Теча', '122'})
  aadd(mArr, {'123 Граждане, принимавшие в 1957-58гг. участие в работах по ликвидации последствий аварии в 1957 году на производственном объединении "Маяк", а также граждане, занятые на работах по проведению мероприятий вдоль реки Теча в 1949-56гг.', '123'})
  aadd(mArr, {'124 Граждане, принимавшие в 1959-61гг. участие в работах по ликвидации последствий аварии в 1957 году на производственном объединении "Маяк", а также граждане, занятые на работах по проведению мероприятий вдоль реки Теча в 1957-62гг.', '124'})
  aadd(mArr, {'125 Граждане, проживающие в населенных пунктах, подвергшихся радиоактивному загрязнению вследствие аварии в 1957 году на производственном объединении "Маяк" и сбросов радиоактивных отходов в реку Теча', '125'})
  aadd(mArr, {'128 Граждане, эвакуированные из населенных пунктов, подвергшихся радиоактивному загрязнению вследствие аварии в 1957 году на производственном объединении "Маяк" и сбросов радиоактивных отходов в реку Теча', '128'})
  aadd(mArr, {'129 Дети первого и второго поколения граждан, указанных в статье 1 Федерального закона от 26.11.98 № 175-ФЗ, страдающие заболеваниями вследствие воздействия радиации на их родителей', '129'})
  aadd(mArr, {'131 Граждане из подразделений особого риска, не имеющие инвалидности', '131'})
  aadd(mArr, {'132 Граждане из подразделений особого риска, имеющие инвалидность', '132'})
  aadd(mArr, {'140 Бывшие несовершеннолетние узники концлагерей, признанные инвалидами вследствие общего заболевания, трудового увечья и других причин (за исключением лиц, инвалидность которых наступила вследствие их противоправных действий)', '140'})
  aadd(mArr, {'141 Рабочие и служащие, а также военнослужащих органов внутренних дел, Государственной противопожарной службы, получившие профессиональные заболевания, связанные с лучевым воздействием на работах в зоне отчуждения', '141'})
  aadd(mArr, {'142 Рабочие и служащие, а также военнослужащие органов внутренних дел, Государственной противопожарной службы, получивших профессиональные заболевания, связанные с лучевым воздействием на работах в зоне отчуждения, ставшие инвалидами', '142'})
  aadd(mArr, {'150 Бывшие несовершеннолетние узники концлагерей', '150'})

  cmdText := 'CREATE TABLE dlo_lgota(kod TEXT(3), name TEXT)'

  fOut:add_string(hb_eol() + 'Классификатор кодов льгот по ДЛО')

  stat_msg('Классификатор кодов льгот по ДЛО')  

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
  fOut:add_string('Обработано ' + str(len(mArr)) + ' узлов.' + hb_eol() )

  return nil

// 13.08.23
function err_csv_prik(db, source, fOut, fError)
  // Классификатор кодов льгот по ДЛО
  //  1 - NAME(C)  2 - KOD(C)

  local cmdText
  local k
  local mKod, mName
  local arr := {}
  local textBeginTrans := 'BEGIN TRANSACTION;'
  local textCommitTrans := 'COMMIT;'
  local count := 0, cmdTextInsert := textBeginTrans

  aadd(arr, {"Неверная команда",1})
  aadd(arr, {"Отсутствует единый номер полиса для полиса ОМС единого образца",2})
  aadd(arr, {'Длина временного номера полиса не равна 9',3})
  aadd(arr, {'Длина нового номера полиса не равна 16 (неверная контрольная сумма)',4})
  aadd(arr, {"Недопустимые знаки или сочетания знаков в фамилии",5})
  aadd(arr, {"Недопустимые знаки или сочетания знаков в имени",6})
  aadd(arr, {"Недопустимые знаки или сочетания знаков в отчестве",7})
  aadd(arr, {"Не указана дата рождения",10})
  aadd(arr, {"Ошибка в дате рождения (указана нереальная дата)",11})
  aadd(arr, {"Указан некорректный СНИЛС",12})
  aadd(arr, {"В строке имеются недопустимые символы",13})
  aadd(arr, {"Неверный порядковый номер файла",19})
  aadd(arr, {"Дата актуализации больше текущей даты",20})
  aadd(arr, {"Ошибка в значении СНИЛС",21})
  aadd(arr, {"Ошибка в контрольном числе СНИЛС",22})
  aadd(arr, {"Неверный код территории",24})
  aadd(arr, {"Отсутствует серия и номер для полиса ОМС старого образца или номер для временного свидетельства",25})
  aadd(arr, {"Ошибка в заголовке метаданных файла",38})
  aadd(arr, {"Ошибка в формате даты прикрепления",46})
  aadd(arr, {"Не указана дата актуализации",86})
  aadd(arr, {"Дата прикрепления больше даты актуализации",87})
  aadd(arr, {"Формат единого номера полиса неверен",102})
  aadd(arr, {"Неверная версия формата",183})
  aadd(arr, {"Не указан СНИЛС медицинского работника",239})
  aadd(arr, {"Не указан код способа прикрепления к МО",242})
  aadd(arr, {"Недопустимый код способа прикрепления к МО",243})
  aadd(arr, {"Дата прикрепления не заполнена",245})
  aadd(arr, {"Ошибка в дате прикрепления",246})
  aadd(arr, {"Реестровый номер МО не указан",264})
  aadd(arr, {"Реестровый номер МО не найден",265})
  aadd(arr, {"Неверный формат реестрового номера МО",300})
  aadd(arr, {"По предоставленным данным застрахованное лицо не найдено в регистре застрахованных лиц",404})
  aadd(arr, {"Единый номер полиса не найден в регистре застрахованных лиц",500})
  aadd(arr, {"Невозможно идентифицировать застрахованное лицо в едином регистре застрахованных лиц",522})
  aadd(arr, {"Единый номер полиса не соответствует указанному документу, подтверждающему факт страхования",525})
  aadd(arr, {"МО не работает на территории",541})
  aadd(arr, {'Застрахованное лицо не прикреплено к МО (для операции "И" не найдена действующая запись о прикреплении)',542})
  aadd(arr, {"Медработник не найден в Федеральном реестре медработников",543})
  aadd(arr, {"Медработник не работает в указанной МО",544})
  aadd(arr, {"Указан второй медработник с той же должностью",545})
  aadd(arr, {"Указан третий медработник (более двух прикреплений)",546})
  aadd(arr, {"Дата прикрепления к медработнику меньше даты прикрепления к МО или предыдущему медработнику",547})
  aadd(arr, {"В реестре отсутствуют сведения по прикреплению указанного лица к МО",548})
  aadd(arr, {"Для лица, не идентифицированного в реестре застрахованных, не указан ЕНП",555})
  aadd(arr, {"Дата заявления, указанная в файле, меньше имеющейся в СРЗ даты прикрепления",600})
  aadd(arr, {"Прикрепление в течение одного года к этой же МО (некорректное прикрепление)",701})
  aadd(arr, {"Прикрепление в течение одного года к другой МО (некорректное прикрепление)",702})
  aadd(arr, {"На указанную дату прикрепления ЗЛ не имеет действующего страхования в Волгоградской области",703})
  aadd(arr, {"Дата прикрепления больше даты смерти",704})
  aadd(arr, {"Неверный способ прикрепления",705})
  aadd(arr, {"Застрахованный умер",706})
  aadd(arr, {"Неверный код способа прикрепления или прикрепление без изменения места жительства в одном году",707})
  aadd(arr, {'Неверная дата прикрепления или неверно указана категория врача',708})
  aadd(arr, {"ЗЛ уже прикреплено к Вашей организации по данным РС СРЗ",709})
  aadd(arr, {"Ошибка в дате открепления",746})
  aadd(arr, {"Обработка данных ЗЛ не выполнялась (направить повторно)",801})
  aadd(arr, {"ЗЛ не найдено в РС СРЗ (проверить данные и направить повторно)",802})
  aadd(arr, {"Наличие ошибок ФЛК, прикладной обработки (проверить данные и направить повторно)",803})
  aadd(arr, {"В программе обработки возникла исключительная ситуация",99})

  cmdText := 'CREATE TABLE err_csv_prik(kod INTEGER, name TEXT)'

  fOut:add_string(hb_eol() + 'Коды ошибок прикрепления населения')

  stat_msg('Коды ошибок прикрепления населения')  

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
  fOut:add_string('Обработано ' + str(len(arr)) + ' узлов.' + hb_eol() )

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

  // 1-код,2-имя,3-ИНН,4-КПП,5-ОГРН,6-адрес,7-банк,8-р.счет,9-БИК
  arr := { ;
    {'34001', ;
     'ФИЛИАЛ ЗАКРЫТОГО АКЦИОНЕРНОГО ОБЩЕСТВА "КАПИТАЛ МЕДИЦИНСКОЕ СТРАХОВАНИЕ" В ГОРОДЕ ВОЛГОГРАДЕ', ;
      '7709028619', ;
      '344343001', ;
      '1028601441274', ;
      '400075 Волгоградская обл., г.Волгоград, ул.Историческая, д.122', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34002', ;
      'ВОЛГОГРАДСКИЙ ФИЛИАЛ АКЦИОНЕРНОГО ОБЩЕСТВА "СТРАХОВАЯ КОМПАНИЯ "СОГАЗ - МЕД"', ;
      '7728170427', ;
      '344343001', ;
      '1027739008440', ;
      '400105 Волгоградская обл., г.Волгоград, ул.Штеменко, д.5', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34003', ;
      'АКЦИОНЕРНОЕ ОБЩЕСТВО ВТБ МЕДИЦИНСКОЕ СТРАХОВАНИЕ', ;
      '7704103750', ;
      '774401001', ;
      '1027739815245', ;
      '400005 Волгоградская обл., г.Волгоград, ул.Мира, д.19', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34004', ;
      'ВОЛГОГРАДСКИЙ ФИЛИАЛ ОБЩЕСТВА С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "СТРАХОВАЯ КОМПАНИЯ ВСК МИЛОСЕРДИЕ"', ;
      '7730519137', ;
      '775001001', ;
      '1057746135325', ;
      '400131 Волгоградская обл., г.Волгоград, ул.Коммунистическая, д.32', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34006', ;
      'ФИЛИАЛ ОБЩЕСТВА С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "МЕДИЦИНСКАЯ СТРАХОВАЯ КОМПАНИЯ "МАКСИМУС" В Г.ВОЛГОГРАДЕ', ;
      '6161056686', ;
      '344445001', ;
      '1106193000022', ;
      '400074 Волгоградская обл., г.Волгоград, ул.Ковровская, д.24', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34007', ;
      'ФИЛИАЛ ОБЩЕСТВА С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ "КАПИТАЛ МЕДИЦИНСКОЕ СТРАХОВАНИЕ" В ВОЛГОГРАДСКОЙ ОБЛАСТИ', ;
      '7813171100', ;
      '344303001', ;
      '1027806865481', ;
      '400074 Волгоградская обл., г.Волгоград, ул.Рабоче-Крестьянская, д.30А', ;
      '', ;
      '', ;
      '' ;
    }, ;
    {'34   ', ;
      'ГОСУДАРСТВЕННОЕ УЧРЕЖДЕНИЕ "ТЕРРИТОРИАЛЬНЫЙ ФОНД ОБЯЗАТЕЛЬНОГО МЕДИЦИНСКОГО СТРАХОВАНИЯ ВОЛГОГРАДСКОЙ ОБЛАСТИ"', ;
      '          ', ;
      '         ', ;
      '1023403856123', ;
      '400005 г.Волгоград, проспект Ленина, 56а', ;
      '', ;
      '', ;
      '' ;
    } ;
  }

  cmdText := 'CREATE TABLE rekv_smo(kod TEXT(5), name TEXT, inn TEXT(10), kpp TEXT(9), ogrn TEXT(13), addres TEXT)'

  fOut:add_string(hb_eol() + 'Страховые компании')

  stat_msg('Страховые компании')  

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
  fOut:add_string('Обработано ' + str(len(arr)) + ' узлов.' + hb_eol() )

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
    fOut:add_string(hb_eol() + nameRef + ' - Справочник ошибок')
  endif

  fOut:add_string(hb_eol() + 'Классификатор кодов ошибок T005')

  stat_msg('Классификатор кодов ошибок T005')  

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
  fOut:add_string('Обработано ' + str(j) + ' узлов.' + hb_eol() )
  return nil

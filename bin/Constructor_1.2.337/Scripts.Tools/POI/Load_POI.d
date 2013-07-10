//Загружает пои из текстового файла по следующему формату
// Название	Широта	Долгота	Полное название	Город	Район	Улица	Номер дома	Телефон	Сайт	Электронная Почта	Время работы	Информация	Класс объекта	Комментарий 1	Комментарий 2	Дата начала рекламы	Дата окончания рекламы	Коммерческое
//аптека	51.667201	36.104557	Аптека Гомеопатическая	Спб	Колпинский	Бульварная	5	+7 (812) 777-7777	www.probki.net	vera@probki.net	с 6 до 10	Отличная аптека	PORTES	0x6100	аптеки	25.10.2011	30.02.2015	1	

include <windows.dh>

local codeByAcro(acro)
{
 
  if(( acro == "POIGEN")||( acro == "Прочие"))
    return 18000;
  if(( acro == "PORTES")||( acro == "Порты"))
    return 18001;
  if(( acro == "HOSPTL" )||( acro == "Больницы"))
    return 18002;
  if(( acro == "SPORTS" )||( acro == "Спортивные сооружения"))
    return 18003;
  if(( acro == "CAFFES" )||( acro == "Кафе"))
    return 18004;
  if(( acro == "RSTRNT" )||( acro == "Рестораны"))
    return 18005;
  if(( acro == "SHOPES" )||( acro == "Магазины"))
    return 18006;
  if(( acro == "HOTELS" )||( acro == "Гостиницы"))
    return 18007;
  if(( acro == "CAMPNG" )||( acro == "Кемпинг"))
    return 18008;
  if(( acro == "PICNIC" )||( acro == "Места отдыха"))
    return 18009;
  if(( acro == "ENTMNT" )||( acro == "Развлечения"))
    return 18010;
  if(( acro == "MUSEUM" )||( acro == "Музеи"))
    return 18011;
  if(( acro == "LIBRRY" )||( acro == "Библиотеки"))
    return 18012;
  if(( acro == "SCHOOL" )||( acro == "Школы"))
    return 18013;
  if(( acro == "INFOMT" )||( acro == "Информация"))
    return 18014;
  if(( acro == "PARKNG" )||( acro == "Парковки"))
    return 18015;
  if(( acro == "TOILET" )||( acro == "Туалеты"))
    return 18016;
  if(( acro == "SHOWER" )||( acro == "Бани"))
    return 18017;
  if(( acro == "DRNWTR" )||( acro == "Питьевая вода"))
    return 18018;
  if(( acro == "TPHONE" )||( acro == "Телефон"))
    return 18019;
  if(( acro == "AIRPOR" )||( acro == "Аэропорты"))
    return 18020;
  if(( acro == "CEMETR" )||( acro == "Кладбища"))
    return 18021;
  if(( acro == "ZOOPRK" )||( acro == "Зоопарки, аквариумы"))
    return 18022;
  if(( acro == "EXHIBT" )||( acro == "Выставочные залы"))
    return 18023;
  if(( acro == "CHURCH" )||( acro == "Церкви"))
    return 18024;
  if(( acro == "MOSQUE" )||( acro == "Мечети"))
    return 18025;
  if(( acro == "SYNGOG" )||( acro == "Синагоги"))
    return 18026;
  if(( acro == "PAGODA" )||( acro == "Пагоды"))
    return 18027;
  if(( acro == "THEATR" )||( acro == "Театры"))
    return 18028;
  if(( acro == "BARCFE" )||( acro == "Бары"))
    return 18029;
  if(( acro == "CINEMA" )||( acro == "Кино"))
    return 18030;
  if(( acro == "MARKET" )||( acro == "Рынки"))
    return 18031;
  if(( acro == "SERVCS" )||( acro == "Услуги"))
    return 18032;
  if(( acro == "PHARMA" )||( acro == "Аптеки"))
    return 18033;
  if(( acro == "POSTES" )||( acro == "Почта"))
    return 18034;
  if(( acro == "BANKES" )||( acro == "Банки"))
    return 18035;
  if(( acro == "BUSSTN" )||( acro == "Автовокзалы"))
    return 18036;
  if(( acro == "CARSRV" )||( acro == "Авторемонт"))
    return 18037;
  if(( acro == "CARCLB" )||( acro == "Авторынки"))
    return 18038;
  if(( acro == "CARWSH" )||( acro == "Автомойки"))
    return 18039;
  if(( acro == "BUSINS" )||( acro == "Бизнес центры"))
    return 18040;
  if(( acro == "TELCOM" )||( acro == "Услуги связи"))
    return 18041;
  if(( acro == "SOCIAL" )||( acro == "Собесы"))
    return 18042;
  if(( acro == "UTILTY" )||( acro == "Коммунальные службы"))
    return 18043;
  if(( acro == "OFFICE" )||( acro == "Государственные учреждения"))
    return 18044;
  if(( acro == "POLICE" )||( acro == "Полиция"))
    return 18045;
  if(( acro == "TRFPOL" )||( acro == "ДПС, ГИБДД"))
    return 18046;
  if(( acro == "EMRGCY" )||( acro == "Экстренные службы"))
    return 18047;
  if(( acro == "JUSTIC" )||( acro == "Суды"))
    return 18048;
  if(( acro == "CONCRT" )||( acro == "Концертные залы"))
    return 18049;
  if(( acro == "CUSTOM" )||( acro == "Таможни"))
    return 18050;
  if(( acro == "FIREHS" )||( acro == "Пожарные станции"))
    return 18051;
  if(( acro == "PARKES" )||( acro == "Парки"))
    return 18052;
  if(( acro == "SCENIC" )||( acro == "Живописные места"))
    return 18053;
  if(( acro == "FACTRY" )||( acro == "Заводы"))
    return 18054;
  if(( acro == "MONMNT" )||( acro == "Памятники"))
    return 18055;
  if(( acro == "BUSSTP" )||( acro == "Остановки транспорта"))
    return 18056;
  if(( acro == "SUBWST" )||( acro == "Метро"))
    return 18057;
  if(( acro == "RAILST" )||( acro == "Вокзалы"))
    return 18058;
  if(( acro == "RADARS" )||( acro == "Радары"))
    return 18059;
  if(( acro == "FUELST" )||( acro == "АЗС, АГЗС"))
    return 18060;
  if(( acro == "FONTAN" )||( acro == "Фонтаны"))
    return 18061;
  if(( acro == "KINDER" )||( acro == "Детские сады"))
    return 18062;
  if(( acro == "COLLEG" )||( acro == "Спец. учебные заведения"))
    return 18063;
  if(( acro == "UNVRTY" )||( acro == "ВУЗы"))
    return 18064;
  if(( acro == "PBLSHR" )||( acro == "Издательства"))
    return 18065;
  if(( acro == "TICKET" )||( acro == "Билетные кассы"))
    return 18066;
  if(( acro == "INTNET" )||( acro == "Интернет"))
    return 18067;
  if(( acro == "CIRCUS" )||( acro == "Цирки"))
    return 18068;
  if(( acro == "TEMPLE" )||( acro == "Храмы"))
    return 18069;
  if(( acro == "SHFOOD" ) ||( acro == "Продуктовые"))
    return 18070;
  if(( acro == "SHCNTR" )||( acro == "Торговые комплексы"))
    return 18071;
  if(( acro == "SHDRSS" )||( acro == "Одежда"))
    return 18072;
  if(( acro == "SHHSGD" )||( acro == "Дом и сад"))
    return 18073;
  if(( acro == "SHFRNT" )||( acro == "Мебель"))
    return 18074;
  if(( acro == "SHSPEC" )||( acro == "Специализированные"))
    return 18075;
  if(( acro == "SHCOMP" )||( acro == "Электроника"))
    return 18076;
  if(( acro == "SHAUTO" )||( acro == "Автосалоны"))
    return 18077;
  if(( acro == "SHSHOE" )||( acro == "Обувь"))
    return 18078;
  if(( acro == "SHGOOD" )||( acro == "Гипермаркеты"))
    return 18079;
  if(( acro == "SHCHEM" )||( acro == "Бытовая химия"))
    return 18080;
  if(( acro == "SHELCT" )||( acro == "Бытовая техника"))
    return 18081;
  if(( acro == "SHPHON" )||( acro == "Мобильные телефоны"))
    return 18082;
  if(( acro == "SHSPRT" )||( acro == "Спорттовары"))
    return 18083;
  if(( acro == "SHGUNS" )||( acro == "Охота, рыбалка"))
    return 18084;
  if(( acro == "SHGIFT" )||( acro == "Подарки"))
    return 18085;
  if(( acro == "SHFLWR" )||( acro == "Цветы"))
    return 18086;
  if(( acro == "SHJEWL" )||( acro == "Ювелирные"))
    return 18087;
  if(( acro == "SHPETS" )||( acro == "Зоомагазины"))
    return 18088;
  if(( acro == "ATMBNK" )||( acro == "Банкоматы"))
    return 18089;
  if(( acro == "CURNCY" )||( acro == "Обмен валюты"))
    return 18090;
  if(( acro == "CARTYR" )||( acro == "Шиномонтаж"))
    return 18091;
  if(( acro == "NOTARY" )||( acro == "Нотариус"))
    return 18092;
  if(( acro == "DENTST" )||( acro == "Стоматология"))
    return 18093;
  if(( acro == "VETNRY" )||( acro == "Ветеринария"))
    return 18094;
  if(( acro == "SHSPAR" )||( acro == "Автозапчасти"))
    return 18095;
  if(( acro == "WIFIST" )||( acro == "Wi-Fi"))
    return 18096;
  if(( acro == "CITYES" )||( acro == "Города"))
    return 18097;
  if(( acro == "TOWNES" )||( acro == "ПГТ"))
    return 18098;
  if(( acro == "STLMNT" )||( acro == "Поселки"))
    return 18099;
  if(( acro == "VILLAG" )||( acro == "Деревни"))
    return 18100;
  if(( acro == "CARENT" )||( acro == "Прокат автомобилей"))
    return 18101;
  if(( acro == "WEIGHT" )||( acro == "Весовые станции"))
    return 18102;
  if(( acro == "AVARIA" )||( acro == "Помощь на дороге"))
    return 18103;
	if(( acro == "PAKNPD" )||( acro == "Водохранилища"))
    return 18105;
	if(( acro == "COMPNY" )||( acro == "Компании"))
    return 18106;
	if(( acro == "OOOMIT" )||( acro == "СитиГид"))
    return 18107;
	if(( acro == "GORODA" )||( acro == "Населённые пункты"))
    return 18108;
	if(( acro == "RNCITY" )||( acro == "Районы города"))
    return 18109;
	if(( acro == "RNOBLS" )||( acro == "Районы"))
    return 18110;
	if(( acro == "CASINO" )||( acro == "Казино"))
    return 18111;
  if(( acro == "CLUBSS" )||( acro == "Клубы"))
    return 18112;
	if(( acro == "WINEDG" )||( acro == "Дегустация вин"))
    return 18113;
  if(( acro == "MEDCTR" )||( acro == "Медицинские Центры"))
    return 18114;
	if(( acro == "POLICL" )||( acro == "Поликлиники"))
    return 18115;
	if(( acro == "BRDSCH" )||( acro == "Интернаты"))
    return 18116;
	if(( acro == "POOLSS" )||( acro == "Бассейны"))
    return 18117;
	if(( acro == "GOLFSS" )||( acro == "Гольф"))
    return 18118;
	if(( acro == "SKATNG" )||( acro == "Лыжные базы"))
    return 18119;
	if(( acro == "DIVING" )||( acro == "Дайвинг"))
    return 18120;
	if(( acro == "PAINBL" )||( acro == "Пейнтбол"))
    return 18121;
	if(( acro == "FITNES" )||( acro == "Фитнес"))
    return 18122;
	if(( acro == "TENNIS" )||( acro == "Теннис"))
    return 18123;
	if(( acro == "SPRPNT" )||( acro == "Спорткомплексы"))
    return 18124;
	if(( acro == "SPRCLB" )||( acro == "Спортклубы"))
    return 18125;
	if(( acro == "STDIUM" )||( acro == "Стадионы"))
    return 18126;
	if(( acro == "SPRNGS" )||( acro == "Реки, озера"))
    return 18127;
	if(( acro == "ISLAND" )||( acro == "Острова"))
    return 18128;
	if(( acro == "WOODPN" )||( acro == "Леса"))
    return 18129;
	if(( acro == "STOPSS" )||( acro == "Остановки общественного транспорта"))
    return 18130;
	if(( acro == "TAXISS" )||( acro == "Такси"))
    return 18131;
	if(( acro == "HOSTEL" )||( acro == "Хостелы"))
    return 18132;
	if(( acro == "PANSNT" )||( acro == "Пансионаты"))
    return 18133;
	if(( acro == "KIDHOT" )||( acro == "Детские лагеря"))
    return 18134;
	if(( acro == "BASTDH" )||( acro == "Базы отдыха"))
    return 18135;
	if(( acro == "SANATR" )||( acro == "Санатории"))
    return 18136;
	if(( acro == "BEACHS" )||( acro == "Пляжи"))
    return 18137;
	if(( acro == "WELLLL" )||( acro == "Источники воды"))
    return 18138;
	if(( acro == "DOSTPR" )||( acro == "Достопримечательности"))
    return 18139;
	if(( acro == "FISHNG" )||( acro == "Места рыбалки"))
    return 18140;
	if(( acro == "EXURSI" )||( acro == "Экскурсии"))
    return 18141;
	if(( acro == "XEROXS" )||( acro == "Копицентры"))
    return 18142;
	if(( acro == "TOURAG" )||( acro == "Турагентства"))
    return 18143;
	if(( acro == "BEAUTY" )||( acro == "Салоны красоты"))
    return 18144;
	if(( acro == "INSURE" )||( acro == "Страхование"))
    return 18145;
	if(( acro == "RITUAL" )||( acro == "Ритуальные услуги"))
    return 18146;
	if(( acro == "NALOGI" )||( acro == "Налоговые службы"))
    return 18147;
	if(( acro == "TSGCOM" )||( acro == "ТСЖ"))
    return 18148;
	if(( acro == "PRISTV" )||( acro == "Приставы"))
    return 18149;
	if(( acro == "KIDSSS" )||( acro == "Для детей"))
    return 18150;
	if(( acro == "COSMTC" )||( acro == "Косметика"))
    return 18151;
	if(( acro == "SHTKAN" )||( acro == "Ткани"))
    return 18152;
	if(( acro == "SHSTRO" )||( acro == "Стройтовары"))
    return 18153;
	if(( acro == "DKDKDK" )||( acro == "ДК"))
    return 18154;
	if(( acro == "REALTY" )||( acro == "Агентства недвижимости"))
    return 18155;
	if(( acro == "CONTRY" )||( acro == "Государства"))
    return 18160;
	if(( acro == "ELEVTH" )||( acro == "Отметки высоты/глубины"))
    return 18161;
	if(( acro == "GEOFCH" )||( acro == "Географические объекты"))
    return 18162;
	if(( acro == "MAYAKS" )||( acro == "Маяки"))
    return 18163;
	if(( acro == "TRAFLT" )||( acro == "Светофоры"))
    return 18164;
	if(( acro == "MREOOO" )||( acro == "МРЭО"))
    return 18165;
	if(( acro == "SUBEXT" )||( acro == "Выходы метро"))
    return 18166;
	if(( acro == "SHTRAF" )||( acro == "Штрафстоянки"))
    return 18167;
	if(( acro == "THPLAZ" )||( acro == "Техноплаза"))
    return 18168;
	if(( acro == "ICEARN" )||( acro == "Ледовая арена"))
    return 18169;
	if(( acro == "ATHLET" )||( acro == "Легкоатлетическая арена"))
    return 18170;
	if(( acro == "FOTBAL" )||( acro == "Футбольная арена"))
    return 18171;
	if(( acro == "BDGPNT" )||( acro == "Мост"))
    return 18172;
	if(( acro == "THINSP" )||( acro == "Техосмотр"))
    return 18173;
	if(( acro == "RAILPT" )||( acro == "Платформы"))
    return 18174;
	if(( acro == "MEDKID" )||( acro == "Медицина детям"))
    return 18175;
    if(( acro == "INFSRV" )||( acro == "Справочные"))
    return 18176;


  return 504;  
}

global main()
{
  if( IDOK != OpenFileDlg(fname,"","Text file (*.txt)|*.txt||") )
    return;
  if( (k=StrRFind(fname,"\\")) > 0 )
    chname=StrMid(fname,k+1);
  else
    chname=fname;
  if( (k=StrRFind(chname,".")) > 0 )
    chname=StrLeft(chname,k-1);
  if( !(fp=fopen(fname,"r")) )
  {
    puts("*** cannot open file "+fname);
    return;
  }
  ea=no=-360;
  we=so=360;
  ln=0;  
  while( fgets(s,512,fp) )
  {
    ln+=1;
    if( !StrLen(s) )
      continue;
    if( StrLeft(s,17) == "NAME\tLT\tLG\t" )
      continue;
    if( (k=StrFind(s,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse: "+s);
      continue;
    }
    ss=StrMid(s,k+3);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse: "+s);
      continue;
    }
    lat=real(StrLeft(ss,k-1));
    if( lat == 0 || lat > 85 || lat < (-85) )
    {
      puts("["+ln+"] suspicious coordinate: "+s);
      continue;
    }
    ss=StrMid(ss,k+3);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse: "+s);
      continue;
    }
    lon=real(StrLeft(ss,k-1));
    if( lon == 0 || lon > 180 || lon < (-180) )
    {
      puts("["+ln+"] suspicious coordinate: "+s);
      continue;
    }
    if( no < lat )
      no=lat;
    if( so > lat )
      so=lat;
    if( we > lon )
      we=lon;
    if( ea < lon )
      ea=lon;      
  }  
  fclose(fp);
  if( !(ver=dsLoad(GetStartPath()+"city_plan")) )
  {
    puts("*** cannot load dictionary city_plan.dic");
    return;
  }
  chSetGeoUnits(1);  
  if( !(ch=chCrtMercatorDataset(chname+".dcf",ver,10000,no,we,int((no+so)/2),"W84",1000)) )
  {
    puts("*** cannot create chart "+chname+".dcf");
    return;
  }  
  StartIndicator("Loading...",ln);
  if( !(fp=fopen(fname,"r")) )
  {
    puts("*** cannot open file "+fname);
    return;
  }
  ln=0;  
  fe=chCrtFeature(ch,60870);                      // chdesc
  chSetAttrText(ch,fe,60010,chname+" POI");       // obname
  chSetAttrText(ch,fe,60020,chname+" ПОИ");       // nobnam
  chSetAttrText(ch,fe,61140,"1");                 // chvers
  chSetAttrText(ch,fe,61150,"0");                 // subver
  chSetAttrText(ch,fe,61070,"db");                // copyrt
  chSetAttrText(ch,fe,61069,"3");                 // codepg
  while( fgets(s,512,fp) )
  {
    ln+=1;
    StepIndicator();
    if( !StrLen(s) )
      continue;
    if( StrLeft(s,17) == "NAME\tLT\tLG\t" )
      continue;
    if( (k=StrFind(s,"\t")) <= 0 )
      continue;
    labels=StrLeft(s,k-1);
    ss=StrMid(s,k+1); //ss=StrMid(s,k+3);
    if( (k=StrFind(ss,"\t")) <= 0 )
      continue;
    lat=real(StrLeft(ss,k-1));
    if( lat == 0 || lat > 85 || lat < (-85) )
      continue;
    ss=StrMid(ss,k+1);
    if( (k=StrFind(ss,"\t")) <= 0 )
      continue;
    lon=real(StrLeft(ss,k-1));
    if( lon == 0 || lon > 180 || lon < (-180) )
      continue;
    ss=StrMid(ss,k+1);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse full_name: "+s);
      continue;
    }
    fulnam=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse city: "+s);
      continue;
    }
    twnnam=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse district: "+s);
      continue;
    }
    dstnam=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse street: "+s);
      continue;
    }
    strnam=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse number: "+s);
      continue;
    }
    number=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse phone: "+s);
      continue;
    }
    phones=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse webpage: "+s);
      continue;
    }
    webpge=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
	
	
	
	
	/////////
	if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse email: "+s);
      continue;
    }
    email=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
	///////
	
	
	
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse time: "+s);
      continue;
    }
    time=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse info: "+s);
      continue;
    }
    inform=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
	//////


	
	
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse acronym: "+s);
      continue;
    }	
    acro=StrLeft(ss,k-1);
    ss=StrMid(ss,k+1);
	
	
	
    if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse cod_mp: "+s);
      continue;
    }
    cod_mp=StrLeft(ss,k-1);
	ss=StrMid(ss,k+1);
	
	
	if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse cg_label: "+s);
      continue;
   }
    cg_label=StrLeft(ss,k-1); 
    ss=StrMid(ss,k+1);
	///
			///////26.10.2011//
	if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse Begining date: "+s);
     continue;
   }
   begdate=StrLeft(ss,k-1);
   ss=StrMid(ss,k+1);
   
   
   
   
   	if( (k=StrFind(ss,"\t")) <= 0 )
    {
      puts("["+ln+"] cannot parse Ending date: "+s);
     continue;
   }
   enddate=StrLeft(ss,k-1);
   ss=StrMid(ss,k+1);
   
   
   
 if( (k=StrFind(ss,"\t")) <= 0 )
  {
   puts("["+ln+"] cannot parse Paid POI: "+s);
  continue;
  }
 paidpoi=StrLeft(ss,k-1);
 ss=StrMid(ss,k+1);

	///////
	
    if( !(code=codeByAcro(acro)) )
    {
      puts("["+ln+"] unknown acronym: "+s);
      continue;
    }
    if( !(nd=chCrtNode(ch,lat,lon)) )
    {
      puts("["+ln+"] cannot set node: "+s);
      continue;
    }
    fe=chCrtFeature(ch,code);
    chSetFeatureNode(ch,fe,nd);
    if( labels )
      chSetAttrText(ch,fe,17501,labels);   
    if( fulnam )
      chSetAttrText(ch,fe,17506,fulnam); 	  
    if( twnnam )
      chSetAttrText(ch,fe,61063,twnnam);    
    if( dstnam )
      chSetAttrText(ch,fe,61062,dstnam);    
    if( strnam )
      chSetAttrText(ch,fe,60030,strnam);     
    if( number )    
      chSetAttrText(ch,fe,60040,number);     
    if( phones )    
      chSetAttrText(ch,fe,17502,phones);     
    if( webpge )    
      chSetAttrText(ch,fe,17504,webpge);     
    if( inform )    
      chSetAttrText(ch,fe,102,inform);   
    if( cod_mp )    
      //chSetAttrText(ch,fe,129,cod_mp);  	
	 chSetAttrValue(ch,fe,129,cod_mp);//
    if( cg_label )    
      chSetAttrText(ch,fe,148,cg_label);  	  
 ////05.10.2011
     if( email )    
      chSetAttrText(ch,fe,17505,email);  	 
////
 ////26.10.2011
     if( time )    
      chSetAttrText(ch,fe,17519,time);  	

     if( begdate )    
      chSetAttrText(ch,fe,17520,begdate); 

     if( enddate )    
      chSetAttrText(ch,fe,17521,enddate); 	
	  
    if( paidpoi )    
      chSetAttrText(ch,fe,17507,paidpoi); 	  	  
////


    chSetAttrText(ch,fe,1703,"26");       // scalvl
    chSetAttrText(ch,fe,1653,"906");      // priort
  //  chSetAttrText(ch,fe,133,"50000");      // scale minimum
	chSetAttrText(ch,fe,61068,"other");      // POI category name
	
	
	
	
//************** блок для создания объектов Graphical text. Всё корректно, кроме цвета. Цвет можно менять только вручную
	
	    if( !(td=chCrtNode(ch,lat,lon)) )
    {
      puts("["+ln+"] cannot set node: "+s);
      continue;
    }
    fe=chCrtFeature(ch,504);
    chSetFeatureNode(ch,fe,td);

    if( labels )    
    chSetAttrText(ch,fe,1668,labels);  
    chSetAttrText(ch,fe,1661,"7");	       //font heigh
	chSetAttrText(ch,fe,1671,"2,5");	       //fntstl
	chSetAttrText(ch,fe,1659,"-200");	       //shiftx
    chSetAttrText(ch,fe,1666,"3");	       //justh
	chSetAttrText(ch,fe,1656,"#545454");	       //color
    chSetAttrText(ch,fe,1703,"26");       // scalvl
    chSetAttrText(ch,fe,1653,"909");      // priort
	//chSetAttrText(ch,fe,133,"40000");      // scale minimum
	chSetAttrText(ch,fe,61068,"other");      // POI category name
	
	//********** конец блока для текстов
	
	
	
	
  }  
  fclose(fp);  
  chFitBorder(ch);
  Load2Editor(ch);
  OverviewDataset(ch);
  FinishIndicator();
  chUpdatePresentation(ch);
  Redraw();
}

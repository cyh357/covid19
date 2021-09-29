import 'dart:convert';

import 'package:covid19/constant.dart';
import 'package:covid19/widgets/counter.dart';
import 'package:covid19/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;

  late int decideCnt;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
    _getInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              title: 'home',
              image: "assets/icons/Drcorona.svg",
              textTop: "All you need",
              textBottom: "is stay at home.",
              offset: offset,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                      value: "서울",
                      items: [
                        '서울',
                        '부산.경남',
                        '경기도',
                        '인천',
                        '제주'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // ElevatedButton(
            //   child: const Text('가져오기',
            //                     style: TextStyle(fontSize: 24),),
            //   onPressed: () {
            //     _getInfo();
            //   },
            // ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Case Update\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "Newest update March 28",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        "See details",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor,
                          number: decideCnt,
                          title: "금일 확진자수",
                        ),
                        Counter(
                          color: kDeathColor,
                          number: 87,
                          title: "Deaths",
                        ),
                        Counter(
                          color: kRecovercolor,
                          number: 46,
                          title: "Recovered",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Spread of Virus",
                        style: kTitleTextstyle,
                      ),
                      Text(
                        "See details",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    height: 178,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/map.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ), 
          ],
        ),
      ),
    );
  }

  void _getInfo() async {

    String sToday = DateTime.now().toString().substring(0,10).replaceAll('-', '');
    String sYesToday = DateTime.now().add(Duration(days: -1)).toString().substring(0,10).replaceAll('-', '');

    String url = 'http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson';
    String queryParams = 'ServiceKey=bixWFcs47G2ln0Kn4vOQvn%2Fyz5alI3jIXXyqgcbnfddYnMOD469Cdbh4PKkWeeDDFNuO4m%2BB%2FvKiE9x7pk6JZw%3D%3D';
    queryParams += '&pageNo=1';
    queryParams += '&numOfRows=10';
    queryParams += '&startCreateDt=$sYesToday';
    queryParams += '&endCreateDt=$sToday';

    //print(queryParams);

    var reqUrl = Uri.parse('$url?$queryParams');
    //print(reqUrl);

    http.Response response = await http.get(
      reqUrl,
    );

    // var responseHeader = response.headers;
    // print("responseHeader: $responseHeader");
    var responseBody = utf8.decode(response.bodyBytes);
    //print("responseBody: $responseBody");

    Xml2Json xml2json = Xml2Json();
    xml2json.parse(responseBody);
    var json = xml2json.toParker();
    var data1 = jsonDecode(json);
    List data2 = data1['response']['body']['items']['item'];

    int decideCnt1 = int.tryParse(data2[0]['decideCnt']) ?? 0;  // 오늘
    int decideCnt2 = int.tryParse(data2[1]['decideCnt']) ?? 0;  // 어제

    setState(() {
      decideCnt = decideCnt1 - decideCnt2;  
    });
    
 
  }
}


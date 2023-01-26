import 'dart:math';
import 'dart:io';

import 'package:alert/alert.dart';
import 'package:blockchain_decentralized_storage_system/provider/data_provider.dart';
import 'package:blockchain_decentralized_storage_system/services/generated/storage-node.pb.dart';
import 'package:blockchain_decentralized_storage_system/services/rpc_calls.dart';
import 'package:blockchain_decentralized_storage_system/structures/node.dart';
import 'package:blockchain_decentralized_storage_system/utils/alerts.dart';
import 'package:blockchain_decentralized_storage_system/widgets/custom_alert_dialogues.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
// import 'package:vs_scrollbar/vs_scrollbar.dart';
import 'package:web3dart/web3dart.dart';

import '../utils/compute_merkle_tree.dart';
import '../widgets/app_branding.dart';

// ignore: must_be_immutable
class Upload extends StatefulWidget {
  Upload({super.key, this.fileMetaData, this.file, this.serversUrls});

  PlatformFile? fileMetaData;
  File? file;
  List<Node>? serversUrls;

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  // var selectedDate = DateTime.now();
  var dateController = TextEditingController();
  bool? _isChecked = false;
  List<NodePingData> nodesData = [];
  bool areAllThePingRequestsCompleted = false;
  bool nodeListHasData = false;
  bool arePingRequestsSent = false;
  final dateRegEx = RegExp(
      r'^(0[1-9]|[12][0-9]|3[01])[\/](0[1-9]|1[012])[\/]((?:19|20)\d\d)$');
  String fileMerkleRoot = '';
  InitTransactionResponse? serverResponse;
  bool isUploading = false;
  double progressBarValue = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateMerkleRoot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: isUploading
            ? page3()
            : arePingRequestsSent
                ? page2()
                : page1(datePickerAction: () async {
                    await datePicker();
                  }),
      ),
    );
  }

  Container page3({datePickerAction}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          AppBranding(profileIconVisibility: 0.0),
          Expanded(
              child: Container(
                  child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (fileMerkleRoot == '')
                  const Text(
                    'Calculating Hash...',
                    style: TextStyle(fontSize: 18.5, color: Color(0xFF494949)),
                  ),
                if (serverResponse == null && fileMerkleRoot != '')
                  const Text(
                    'Connecting Server...',
                    style: TextStyle(fontSize: 18.5, color: Color(0xFF494949)),
                  ),
                if (serverResponse != null && fileMerkleRoot != '')
                  const Text(
                    'Uploading...',
                    style: TextStyle(fontSize: 18.5, color: Color(0xFF494949)),
                  ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    child: LinearProgressIndicator(
                      value: progressBarValue,
                      minHeight: 4,
                      backgroundColor: const Color(0xFF4859A0).withOpacity(0.4),
                      color: Color(0xFF4859A0),
                    ),
                  ),
                )
              ],
            ),
          )))
        ],
      ),
    );
  }

  Container page2({datePickerAction}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 25,
          ),
          AppBranding(profileIconVisibility: 0.0),
          SizedBox(
            height: 35,
          ),
          fileName(
              name: widget.fileMetaData!.name,
              size: (widget.fileMetaData!.size / 1024).ceil()),
          SizedBox(
            height: 25,
          ),
          title('Select Storage Node'),
          SizedBox(
            height: 5,
          ),
          subtitle(),
          !nodeListHasData
              ? areAllThePingRequestsCompleted
                  ? Expanded(
                      child: Container(
                        child: Center(
                          child: Text(
                            'No servers found',
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.4)),
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        child: Center(
                          child: JumpingDotsProgressIndicator(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    )
              : serverTiles()
        ],
      ),
    );
  }

  Expanded serverTiles() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [for (var serverNode in nodesData) serverTile(serverNode)],
        ),
      ),
    );
  }

  Widget serverTile(NodePingData serverNode) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isUploading = true;
        });
        try {
          transactionRequestToServer(serverNode).then((response) async {
            await uploadFile(
                file: widget.file!, initTransactionResponse: serverResponse!);
            Navigator.pop(context);
            Alert(message: 'File uploaded').show();
          });
        } catch (e) {
          setState(() {
            isUploading = false;
          });
          showErrorAlert(context);
          e.toString();
        }
      },
      child: Row(
        children: [
          Container(
            width: 130,
            padding: EdgeInsets.only(left: 0),
            child: Scrollbar(
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    child: SelectableText(
                      serverNode.node.address,
                      style: TextStyle(color: Colors.blue),
                    ),
                  )),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Row(
            children: [
              Text(
                '${EtherAmount.inWei(BigInt.parse(serverNode.bidPrice)).getValueInUnit(EtherUnit.ether).toStringAsFixed(5)}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                width: 2,
              ),
              ImageIcon(
                AssetImage('images/ether.png'),
                size: 12,
                color: Colors.grey,
              )
            ],
          )),
          SizedBox(
            width: 20,
          ),
          Expanded(
              child: Text(
            '${serverNode.responseTimeInMilliseconds}ms',
            style: TextStyle(color: Colors.grey),
          )),
        ],
      ),
    );
  }

  Padding subtitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 130,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                'Node',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              'Fee',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              'Latency',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Container page1({datePickerAction}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25,
              ),
              AppBranding(profileIconVisibility: 0.0),
              SizedBox(
                height: 35,
              ),
              fileName(
                  name: widget.fileMetaData!.name,
                  size: (widget.fileMetaData!.size / 1024).ceil()),
              SizedBox(
                height: 25,
              ),
              datePickerTextField(action: datePickerAction),
              SizedBox(
                height: 25,
              ),
              checkBox(),
            ],
          ),
          Column(
            children: [
              button(),
              SizedBox(
                height: 25,
              ),
            ],
          )
        ],
      ),
    );
  }

  Column datePickerTextField({action}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('Select Duration'),
        SizedBox(
          height: 15,
        ),
        TextField(
          controller: dateController,
          onChanged: (value) {
            setState(() {
              dateController.text = value;
              dateController.selection =
                  TextSelection.collapsed(offset: dateController.text.length);
            });
          },
          keyboardType: TextInputType.datetime,
          decoration: InputDecoration(
              fillColor: Color(0xFFFAFAFA),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 17.5),
              isCollapsed: true,
              suffixIcon: GestureDetector(
                onTap: action,
                child: Icon(
                  Icons.date_range,
                  color: Colors.black,
                ),
              ),
              hintText: 'dd/mm/yyyy'),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          'You pay for this duration only',
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Container button() {
    bool isDateCorrectlyFormatted = dateRegEx.hasMatch(dateController.text);

    bool isDateDurationCorrect = false;
    if (dateController.text != '')
      try {
        // var dateList = dateController.text.split('/');
        // var selectedDate = DateTime(int.parse(dateList[2]),
        //     int.parse(dateList[1]), int.parse(dateList[0]));
        var selectedDate = getSelectedDate();

        isDateDurationCorrect =
            selectedDate.difference(DateTime.now()).inSeconds > 0;
      } catch (e) {
        print(e.toString());
      }

    return Container(
      decoration: BoxDecoration(
          color: (!(isDateCorrectlyFormatted && isDateDurationCorrect))
              ? Colors.grey
              : Color(0xFF4859A0),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextButton(
        onPressed: (!(isDateCorrectlyFormatted && isDateDurationCorrect))
            ? null
            : () async {
                pingRequestToServers();
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Next',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 15.5,
            )
          ],
        ),
      ),
    );
  }

  Column checkBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('Encryption'),
        SizedBox(
          height: 15,
        ),
        Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (bool? value) {
                setState(() {
                  _isChecked = value;
                });
              },
            ),
            Text(
              'Encrypt file',
              style: TextStyle(fontSize: 18),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          'Expect larger size when encryption is enabled',
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget title(text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: Color(0xFF4859A0).withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Column fileName({name, size}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title('File Name'),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Row(
            children: [
              Image.asset(
                'images/file.png',
                height: 30,
                width: 30,
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '${size}kb',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  datePicker() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF4859A0).withOpacity(0.6),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Color(0xFF4859A0).withOpacity(0.6),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        dateController.text =
            '${dateCorrector(picked.day)}/${dateCorrector(picked.month)}/${picked.year}';
      });
  }

  dateCorrector(date) {
    String s = date.toString();
    if (s.length < 2) return '0$s';
    return s;
  }

  pingRequestToServers() async {
    // var dateList = dateController.text.split('/');
    var selectedDate = getSelectedDate();
    //  DateTime(
    //     int.parse(dateList[2]), int.parse(dateList[1]), int.parse(dateList[0]));
    var duration = selectedDate.difference(DateTime.now()).inSeconds;
    setState(() {
      arePingRequestsSent = true;
    });
    for (var index = 0; index < widget.serversUrls!.length; index++) {
      final stopwatch = Stopwatch()..start();
      try {
        StorageNode storageNode =
            StorageNode(address: widget.serversUrls![index].url);
        storageNode
            .ping(
                fileSize: Int64(widget.fileMetaData!.size),
                segmentCount: (widget.fileMetaData!.size / 1024).ceil(),
                bidPrice: '0',
                timePeriod: Int64(duration))
            .then((response) {
          NodePingData nodePingData = NodePingData(
              bidPrice: response.bidPrice,
              //  EtherAmount.inWei(BigInt.parse(response.bidPrice))
              //     .getValueInUnit(EtherUnit.ether),
              canStore: response.canStore,
              responseTimeInMilliseconds: stopwatch.elapsed.inMilliseconds,
              node: widget.serversUrls![index]);
          nodesData.add(nodePingData);
          stopwatch.stop();
          setState(() {
            nodeListHasData = true;
          });
          if (index == widget.serversUrls!.length) {
            setState(() {
              areAllThePingRequestsCompleted = true;
            });
          }
        });
      } catch (e) {
        stopwatch.stop();
        if (index == widget.serversUrls!.length) {
          setState(() {
            areAllThePingRequestsCompleted = true;
          });
        }
        print(e.toString());
        // showErrorAlert(context);
      }
    }
  }

  DateTime getSelectedDate() {
    var dateList = dateController.text.split('/');
    var selectedDate = DateTime(
        int.parse(dateList[2]), int.parse(dateList[1]), int.parse(dateList[0]));
    return selectedDate;
  }

  transactionRequestToServer(NodePingData nodePingData) async {
    var dataProvider = Provider.of<DataProvider>(context, listen: false);
    StorageNode storageNode = StorageNode(address: nodePingData.node.url);
    var currentDate = DateTime.now();
    var selectedDate = getSelectedDate();

    InitTransactionResponse initTransactionResponse =
        await storageNode.initTransaction(
            fileSize: Int64(widget.fileMetaData!.size),
            segmentsCount: Int64((widget.fileMetaData!.size / 1024).ceil()),
            fileHash: fileMerkleRoot,
            bid: nodePingData.bidPrice,
            userAddress: dataProvider.accountAddress,
            timeStart: Int64(currentDate.millisecondsSinceEpoch ~/ 1000),
            timeEnd: Int64(selectedDate.millisecondsSinceEpoch ~/ 1000),
            concludeTimeout: Int64(40),
            proveTimeout: Int64(40));

    setState(() {
      serverResponse = initTransactionResponse;
    });
  }

  calculateMerkleRoot() async {
    List<Uint8List> merkleTree = await fileMerkleTree(widget.file);
    String merkleRoot = HEX.encode(merkleTree[merkleTree.length - 1]);
    setState(() {
      fileMerkleRoot = merkleRoot;
    });
  }

  uploadFile(
      {required File file,
      required InitTransactionResponse initTransactionResponse}) async {
    var dio = Dio();
    FormData formData = new FormData.fromMap({"file": file});
    var response = await dio.post(
      "${initTransactionResponse.httpURL}",
      data: formData,
      options: Options(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
        headers: {"Authorization": "Bearer ${initTransactionResponse.jWT}"},
      ),
      onSendProgress: (count, total) {
        setState(() {
          progressBarValue = total / count;
        });
      },
    );
  }
}

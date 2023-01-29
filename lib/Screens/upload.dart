import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:blockchain_decentralized_storage_system/utils/bytes_calculator.dart';
import 'package:blockchain_decentralized_storage_system/utils/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as en;
import 'package:alert/alert.dart';
import 'package:blockchain_decentralized_storage_system/provider/database_provider.dart';
import 'package:blockchain_decentralized_storage_system/services/generated/storage-node.pb.dart';
import 'package:blockchain_decentralized_storage_system/services/rpc_calls.dart';
import 'package:blockchain_decentralized_storage_system/structures/node.dart';
import 'package:blockchain_decentralized_storage_system/utils/alerts.dart';
import 'package:blockchain_decentralized_storage_system/widgets/custom_alert_dialogues.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hex/hex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:path/path.dart';
import 'package:web_socket_channel/io.dart';
import '../services/smart_contract_helper_methods.dart';
import '../utils/compute_merkle_tree.dart';
import '../widgets/app_branding.dart';

import 'package:web3dart/src/utils/length_tracking_byte_sink.dart';
import 'package:http/http.dart' as http;

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
  late http.Client httpClient = http.Client();
  late Web3Client ethClient =
      Web3Client(HTTP_URL, httpClient, socketConnector: () {
    return IOWebSocketChannel.connect(HTTP_URL).cast<String>();
  });
  var dateController = TextEditingController();
  List<NodePingData> nodesData = [];
  bool areAllThePingRequestsCompleted = false;
  bool nodeListHasData = false;
  bool arePingRequestsSent = false;
  final dateRegEx = RegExp(
      r'^(0[1-9]|[12][0-9]|3[01])[\/](0[1-9]|1[012])[\/]((?:19|20)\d\d)$');
  String fileMerkleRoot = '';
  InitTransactionResponse? serverResponse;
  bool isEncryptingFile = false;
  bool isUploading = false;
  double progressBarValue = 0.0;

  int timeStart = 0;
  int timeEnd = 0;

  int isEncrypted = 0;

  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context);
    print(
        'Account Address: ${databaseProvider.accountTableItems[0]['address']}');
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: isUploading
            ? page3()
            : arePingRequestsSent
                ? page2(databaseProvider: databaseProvider)
                : page1(datePickerAction: () async {
                    await datePicker();
                  }),
      ),
    );
  }

  Container page3() {
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
                if (isEncryptingFile)
                  const Text(
                    'Encrypting File...',
                    style: TextStyle(fontSize: 18.5, color: Color(0xFF494949)),
                  ),
                if (fileMerkleRoot == '' && !isEncryptingFile)
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

  Container page2({required DatabaseProvider databaseProvider}) {
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
              size: formatBytes(widget.fileMetaData!.size)),
          //  (widget.fileMetaData!.size / 1024).ceil()),
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
              : serverTiles(databaseProvider: databaseProvider)
        ],
      ),
    );
  }

  Expanded serverTiles({required DatabaseProvider databaseProvider}) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var serverNode in nodesData)
              serverTile(serverNode, databaseProvider: databaseProvider)
          ],
        ),
      ),
    );
  }

  Widget serverTile(NodePingData serverNode,
      {required DatabaseProvider databaseProvider}) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isUploading = true;
        });
        try {
          String merkleRoot = await calculateMerkleRoot(databaseProvider);
          print('merkle');
          print(merkleRoot);
          InitTransactionResponse transactionResponse =
              await transactionRequestToServer(serverNode, databaseProvider);
          dynamic uploadResponse = await uploadFile(
              file: widget.file!, initTransactionResponse: transactionResponse);
          if (uploadResponse['ok']) {
            Future.delayed(Duration(seconds: 2), () async {
              String concludeTransactionResponse =
                  await concludeTransactionWithServer(
                      serverNode: serverNode,
                      databaseProvider: databaseProvider);
              await saveFileReferenceToDatabase(
                  databaseProvider: databaseProvider, nodePingData: serverNode);
            });
          }
        } catch (e) {
          setState(() {
            isUploading = false;
          });
          showErrorAlert(this.context);
          print(e.toString());
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
                  size: formatBytes(widget.fileMetaData!.size)
                  //  (widget.fileMetaData!.size / 1024).ceil()
                  ),
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
              value: isEncrypted == 1 ? true : false,
              onChanged: (bool? value) {
                setState(() {
                  isEncrypted = value == true ? 1 : 0;
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
          // overflow: TextOverflow.ellipsis,
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
              Expanded(
                child: Column(
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
                      '${size}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  datePicker() async {
    DateTime? picked = await showDatePicker(
      context: this.context,
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
    var selectedDate = getSelectedDate();
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

  Future<InitTransactionResponse> transactionRequestToServer(
      NodePingData nodePingData, DatabaseProvider databaseProvider) async {
    // try {
    StorageNode storageNode = StorageNode(address: nodePingData.node.url);
    var currentDate = DateTime.now();
    var selectedDate = getSelectedDate();

    final start = currentDate.millisecondsSinceEpoch ~/ 1000;
    final end = selectedDate.millisecondsSinceEpoch ~/ 1000;

    setState(() {
      timeStart = start;
      timeEnd = end;
    });

    InitTransactionResponse initTransactionResponse =
        await storageNode.initTransaction(
            fileSize: Int64(widget.fileMetaData!.size),
            segmentsCount: Int64((widget.fileMetaData!.size / 1024).ceil()),
            fileHash: fileMerkleRoot,
            bid: nodePingData.bidPrice,
            userAddress: databaseProvider.accountTableItems[0]['address'],
            timeStart: Int64(start),
            timeEnd: Int64(end),
            concludeTimeout: Int64(216000),
            proveTimeout: Int64(216000));

    setState(() {
      serverResponse = initTransactionResponse;
    });
    return initTransactionResponse;
  }

  Future<String> calculateMerkleRoot(DatabaseProvider databaseProvider) async {
    if (isEncrypted == 1) {
      setState(() {
        isEncryptingFile = true;
      });
    }
    Uint8List fileBytes = await widget.file!.readAsBytes();
    if (isEncrypted == 1) {
      fileBytes = await encryptFile(
          databaseProvider: databaseProvider, fileBytes: fileBytes);
    }
    List<Uint8List> merkleTree = fileMerkleTree(fileBytes);
    String merkleRoot = HEX.encode(merkleTree[merkleTree.length - 1]);
    setState(() {
      fileMerkleRoot = merkleRoot;
    });
    return fileMerkleRoot;
  }

  Future<Uint8List> encryptFile(
      {required DatabaseProvider databaseProvider,
      required Uint8List fileBytes}) async {
    String privateKey = databaseProvider.accountTableItems[0]['address'];
    var bytes = utf8.encode(privateKey);
    var digest = sha256.convert(bytes);

    // print('private key: $privateKey');
    // print('sha256 encryption: ${digest.toString()}');
    // print('key for encryption: ${digest.toString().substring(0, 32)}');

    final key = en.Key.fromUtf8(digest.toString().substring(0, 32));
    final iv = IV.fromUtf8(iv_key);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted encrypted = encrypter.encryptBytes(fileBytes, iv: iv);
    Uint8List encryptedFileBytes = encrypted.bytes;
    await copyEncryptedFileToTempDir(encryptedFileBytes);

    return encryptedFileBytes;
  }

  copyEncryptedFileToTempDir(Uint8List encryptedFileBytes) async {
    var tempDir = await getTemporaryDirectory();
    String newPath = join(tempDir.path, widget.fileMetaData!.name);
    File file = await File(newPath).writeAsBytes(encryptedFileBytes);
    setState(() {
      widget.file = file;
      isEncryptingFile = false;
    });
  }

  Future<void> deleteEncryptedFileFromTempDir() async {
    if (isEncrypted == 1) {
      await widget.file!.delete();
    }
  }

  Future<dynamic> uploadFile(
      {required File file,
      required InitTransactionResponse initTransactionResponse}) async {
    // try {
    var dio = Dio();
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path,
          filename: widget.fileMetaData!.name)
    });
    Response response = await dio.post(
      "${initTransactionResponse.httpURL}",
      data: formData,
      options: Options(
        followRedirects: false,
        validateStatus: (status) => true,
        headers: {"Authorization": "Bearer ${initTransactionResponse.jWT}"},
      ),
      onSendProgress: (count, total) {
        if (mounted)
          setState(() {
            progressBarValue = count / total;
          });
      },
    );

    return jsonDecode(response.data);
  }

  Future<String> concludeTransactionWithServer(
      {required NodePingData serverNode,
      required DatabaseProvider databaseProvider}) async {
    String address = databaseProvider.accountTableItems[0]['address'];
    String privateKey = databaseProvider.accountTableItems[0]['private_key'];
    var credentials = await ethClient.credentialsFromPrivateKey(privateKey);
    EthereumAddress accountAddress = EthereumAddress(hexToBytes(address));
    Uint8List fileMerkleRootBytes = hexToBytes(fileMerkleRoot);

    final contract = await loadContract(
        name: storageNode,
        path: "assets/storage-contract-abi.json",
        address: serverNode.node.address);
    final ethFunction = contract.function(concludeTransaction);

    final response = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          value: EtherAmount.inWei(BigInt.from(int.parse(serverNode.bidPrice))),
          parameters: [
            BigInt.from(1),
            accountAddress,
            fileMerkleRootBytes,
            BigInt.from(widget.fileMetaData!.size),
            BigInt.from(timeStart),
            BigInt.from(timeEnd),
            BigInt.from(216000),
            BigInt.from(216000),
            BigInt.from((widget.fileMetaData!.size / 1024).ceil()),
            BigInt.from(int.parse(serverNode.bidPrice))
          ],
        ),
        chainId: 420);
    return response;
  }

  Future<void> saveFileReferenceToDatabase(
      {required DatabaseProvider databaseProvider,
      required NodePingData nodePingData}) async {
    final secondsSinceEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    Map<String, dynamic> row = {
      'file_key': getfileHash(databaseProvider: databaseProvider),
      'bid': nodePingData.bidPrice,
      'name': widget.fileMetaData!.name,
      'contract_address': nodePingData.node.address,
      'file_size': widget.fileMetaData!.size,
      'merkle_root': fileMerkleRoot,
      'segments': (widget.fileMetaData!.size / 1024).ceil(),
      'timer_start': timeStart,
      'timer_end': timeEnd,
      'time_created': secondsSinceEpoch,
      'last_verified': secondsSinceEpoch,
      'conclude_timeout': 216000,
      'prove_timeout': 216000,
      'sha256': '',
      'is_encrypted': isEncrypted,
    };
    databaseProvider.addFilesTableRow(row);
    await deleteEncryptedFileFromTempDir();
    exitToHomeScreenWithAnAlert();
  }

  exitToHomeScreenWithAnAlert() {
    Navigator.pop(this.context);
    Alert(message: 'Uploaded successfully').show();
  }

  getfileHash({required DatabaseProvider databaseProvider}) {
    String address = databaseProvider.accountTableItems[0]['address'];

    EthereumAddress data = EthereumAddress(hexToBytes(address));
    LengthTrackingByteSink buffer = LengthTrackingByteSink();

    final addressType = AddressType();
    addressType.encode(data, buffer);

    BytesBuilder fileHashList = BytesBuilder()
      ..add(buffer.asBytes())
      ..add(hexToBytes(fileMerkleRoot));

    String fileHash = bytesToHex(chunkSha3Encoding(fileHashList.toBytes()));

    return fileHash;
  }
}

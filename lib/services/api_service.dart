import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String url = "https://pos-eric.newbiehost.xyz";

  late Map<String, dynamic> user;
  late String endpoint;

  getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    user = jsonDecode(localStorage.getString('userData')!);
  }

  getEndpoint() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    endpoint = localStorage.getString('endpoint')!;
  }

  login(data) async {
    await getEndpoint();
    var fullUrl = '$endpoint/mobile/auth/login';
    return await http.post(Uri.parse(fullUrl), body: data);
  }

  logout() async {
    await getEndpoint();
    await getUser();
    var fullUrl = '$endpoint/mobile/auth/logout';
    return await http.post(Uri.parse(fullUrl), body: {
      'username': user['username'],
      'password': user['password'],
    });
  }

  getProfile() async {
    await getEndpoint();
    await getUser();
    var fullUrl = "$endpoint/mobile/profile/list?username=${user['username']}";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  editProfile(data) async {
    await getEndpoint();
    await getUser();
    var fullUrl = '$endpoint/mobile/profile/edit';
    return await http.post(
      Uri.parse(fullUrl),
      body: data,
      headers: setHeaders(),
    );
  }

  getConfiguration() async {
    await getEndpoint();
    await getUser();
    var fullUrl = "$endpoint/mobile/configurasi/list";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getCategories({name = '', limit = 1, offset = 50}) async {
    await getEndpoint();
    await getUser();
    var fullUrl =
        "$endpoint/mobile/kategori/list?nama_kategori=$name&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getItems({
    name = '',
    category = '',
    limit = 1,
    offset = 50,
    idCustomer = 1,
  }) async {
    await getEndpoint();
    await getUser();
    var fullUrl =
        "$endpoint/mobile/items/list?nama_barang=$name&nama_kategori=$category&limit=$limit&offset=$offset&id_customer=$idCustomer";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getCustomers({name = '', limit = 1, offset = 50}) async {
    await getEndpoint();
    await getUser();
    var fullUrl =
        "$endpoint/mobile/customer/list?nama_customer=$name&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getKaryawan({name = '', limit = 1, offset = 50}) async {
    await getEndpoint();
    await getUser();
    var fullUrl =
        "$endpoint/mobile/karyawan/list?nama_karyawan=$name&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getReportSalesOrder({
    nameCustomer = '',
    fromDate = '',
    toDate = '',
    limit = 1,
    offset = 50,
  }) async {
    await getEndpoint();
    await getUser();
    var fullUrl =
        "$endpoint/mobile/order/list?nama_customer=$nameCustomer&dari_tanggal=$fromDate&sampai_tanggal=$toDate&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  postSalesOrder({data, type}) async {
    await getEndpoint();
    await getUser();
    var fullUrl = '$endpoint/mobile/order/$type';
    return await http.post(
      Uri.parse(fullUrl),
      body: data,
      headers: setHeaders(),
    );
  }

  cancelSalesOrder(data) async {
// {
//     "no_order": "SO-240423-142526"
// }

    await getEndpoint();
    await getUser();
    var fullUrl = '$endpoint/mobile/order/cancel';
    return await http.post(
      Uri.parse(fullUrl),
      body: data,
      headers: setHeaders(),
    );
  }

  postSalesOrderItem({data, type}) async {
    await getEndpoint();
    await getUser();
    var fullUrl = '$endpoint/mobile/items/$type';
    return await http.post(
      Uri.parse(fullUrl),
      body: data,
      headers: setHeaders(),
    );
  }

  deleteSalesOrderItem(data) async {
    await getEndpoint();
    await getUser();
    var fullUrl = '$endpoint/mobile/items/delete';
    return await http.post(
      Uri.parse(fullUrl),
      body: data,
      headers: setHeaders(),
    );
  }

  getReportSalesOrderDetail(number) async {
    await getEndpoint();
    await getUser();
    var fullUrl = "$endpoint/mobile/order/detail/list?nomor_so=$number";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getReportInvoice({
    nameCustomer = '',
    fromDate = '',
    toDate = '',
    limit = 1,
    offset = 50,
  }) async {
    await getEndpoint();
    await getUser();
    var fullUrl =
        "$endpoint/mobile/invoice/list?nama_customer=$nameCustomer&dari_tanggal=$fromDate&sampai_tanggal=$toDate&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getReportInvoiceDetail(id) async {
    await getEndpoint();
    await getUser();
    var fullUrl = "$endpoint/mobile/invoice/detail/list?id_penjualan=$id";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  Map<String, String> setHeaders() => {
        'username': user['username'],
        'password': user['password'],
      };
}

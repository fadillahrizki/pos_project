import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String url = "https://pos-eric.newbiehost.xyz/mobile";

  late Map<String, dynamic> user;

  getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    user = jsonDecode(localStorage.getString('userData')!);
  }

  login(data) async {
    var fullUrl = '$url/auth/login';
    return await http.post(Uri.parse(fullUrl), body: data);
  }

  logout() async {
    await getUser();
    var fullUrl = '$url/auth/logout';
    return await http.post(Uri.parse(fullUrl), body: {
      'username': user['username'],
      'password': user['password'],
    });
  }

  getProfile() async {
    await getUser();
    var fullUrl = "$url/profile/list?username=${user['username']}";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  editProfile(data) async {
    await getUser();
    var fullUrl = '$url/profile/edit';
    return await http.post(
      Uri.parse(fullUrl),
      body: data,
      headers: setHeaders(),
    );
  }

  getConfiguration() async {
    await getUser();
    var fullUrl = "$url/configurasi/list";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getCategories({name = '', limit = 1, offset = 10}) async {
    await getUser();
    var fullUrl =
        "$url/kategori/list?nama_kategori=$name&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getItems({
    name = '',
    category = '',
    limit = 1,
    offset = 10,
    idCustomer = 1,
  }) async {
    await getUser();
    var fullUrl =
        "$url/items/list?nama_barang=$name&nama_kategori=$category&limit=$limit&offset=$offset&id_customer=$idCustomer";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getCustomers({name = '', limit = 1, offset = 10}) async {
    await getUser();
    var fullUrl =
        "$url/customer/list?nama_customer=$name&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getKaryawan({name = '', limit = 1, offset = 10}) async {
    await getUser();
    var fullUrl =
        "$url/karyawan/list?nama_karyawan=$name&limit=$limit&offset=$offset";
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
    offset = 10,
  }) async {
    await getUser();
    var fullUrl =
        "$url/order/list?nama_customer=$nameCustomer&dari_tanggal=$fromDate&sampai_tanggal=$toDate&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getReportSalesOrderDetail(number) async {
    await getUser();
    var fullUrl = "$url/order/detail/list?nomor_so=$number";
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
    offset = 10,
  }) async {
    await getUser();
    var fullUrl =
        "$url/invoice/list?nama_customer=$nameCustomer&dari_tanggal=$fromDate&sampai_tanggal=$toDate&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: setHeaders(),
    );
  }

  getReportInvoiceDetail(id) async {
    await getUser();
    var fullUrl = "$url/invoice/detail/list?id_penjualan=$id";
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

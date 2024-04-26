import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _url = "https://pos-eric.newbiehost.xyz/mobile";

  late Map<String, dynamic> user;

  _getUser() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    user = jsonDecode(localStorage.getString('userData')!);
  }

  login(data) async {
    var fullUrl = '$_url/auth/login';
    return await http.post(Uri.parse(fullUrl), body: data);
  }

  logout() async {
    await _getUser();
    var fullUrl = '$_url/auth/logout';
    return await http.post(Uri.parse(fullUrl), body: {
      'username': user['username'],
      'password': user['password'],
    });
  }

  getProfile() async {
    await _getUser();
    var fullUrl = "$_url/profile/list?username=${user['username']}";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  editProfile(data) async {
    await _getUser();
    var fullUrl = '$_url/profile/edit';
    return await http.post(
      Uri.parse(fullUrl),
      body: data,
      headers: _setHeaders(),
    );
  }

  getConfiguration() async {
    await _getUser();
    var fullUrl = "$_url/configurasi/list";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  editConfiguration(data) async {
    await _getUser();
    var fullUrl = '$_url/configurasi/edit';
    return await http.post(
      Uri.parse(fullUrl),
      body: data,
      headers: _setHeaders(),
    );
  }

  getCategories({name = '', limit = 1, offset = 10}) async {
    await _getUser();
    var fullUrl =
        "$_url/kategori/list?nama_kategori=$name&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  getItems({name = '', category = '', limit = 1, offset = 10}) async {
    await _getUser();
    var fullUrl =
        "$_url/items/list?nama_barang=$name&nama_kategori=$category&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  getCustomers({name = '', limit = 1, offset = 10}) async {
    await _getUser();
    var fullUrl =
        "$_url/customer/list?nama_customer=$name&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  getKaryawan({name = '', limit = 1, offset = 10}) async {
    await _getUser();
    var fullUrl =
        "$_url/karyawan/list?nama_karyawan=$name&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  getReportSalesOrder({
    nameCustomer = '',
    fromDate = '',
    toDate = '',
    limit = 1,
    offset = 10,
  }) async {
    await _getUser();
    var fullUrl =
        "$_url/order/list?nama_customer=$nameCustomer&dari_tanggal=$fromDate&sampai_tanggal=$toDate&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  getReportSalesOrderDetail(number) async {
    await _getUser();
    var fullUrl = "$_url/order/detail/list?nomor_so=$number";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  getReportInvoice({
    nameCustomer = '',
    fromDate = '',
    toDate = '',
    limit = 1,
    offset = 10,
  }) async {
    await _getUser();
    var fullUrl =
        "$_url/invoice/list?nama_customer=$nameCustomer&dari_tanggal=$fromDate&sampai_tanggal=$toDate&limit=$limit&offset=$offset";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  getReportInvoiceDetail(id) async {
    await _getUser();
    var fullUrl = "$_url/invoice/detail/list?id_penjualan=$id";
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  Map<String, String> _setHeaders() => {
        'username': user['username'],
        'password': user['password'],
      };
}

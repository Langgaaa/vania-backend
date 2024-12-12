import 'package:vania/vania.dart';
import 'package:tugas_backend/app/models/customers.dart' as CustomerstModel;
import 'package:vania/src/exception/validation_exception.dart';

class CustomersController extends Controller {
  final model = CustomerstModel.Customers();
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'cust_name': 'required|string|max_length:100',
        'cust_address': 'required|string|max_length:255',
        'cust_city': 'required|string|max_length:255',
        'cust_state': 'required|string|max_length:255',
        'cust_zip': 'required|string|max_length:255',
        'cust_country': 'required|string|max_length:255',
        'cust_telp': 'required|string|max_length:255',
      }, {
        'cust_name.required': 'Nama customer wajib diisi.',
        'cust_name.string': 'Nama customer harus berupa teks.',
        'cust_name.max_length': 'Nama customer maksimal 100 karakter.',
        'cust_addres.required': 'Alamat customer wajib diisi.',
        'cust_addres.string': 'Alamat customer harus berupa teks.',
        'cust_address.max_length': 'Alamat customer maksimal 100 karakter.',
        'cust_city.required': 'Kota customer wajib diisi.',
        'cust_city.string': 'Kota customer harus berupa teks.',
        'cust_city.max_length': 'Kota customer maksimal 100 karakter.',
        'cust_state.required': 'Provinsi customer wajib diisi.',
        'cust_state.string': 'Provinsi customer harus berupa teks.',
        'cust_state.max_length': 'Provinsi customer maksimal 100 karakter.',
        'cust_zip.required': 'Kode pos customer wajib diisi.',
        'cust_zip.string': 'Kode pos customer harus berupa teks.',
        'cust_zip.max_length': 'Kode pos customer maksimal 100 karakter.',
        'cust_country.required': 'Negara customer wajib diisi.',
        'cust_country.string': 'Negara customer harus berupa teks.',
        'cust_country.max_length': 'Negara customer maksimal 100 karakter.',
        'cust_telp.required': 'No. Telp customer wajib diisi.',
        'cust_telp.string': 'No. Telp customer bisa berupa angka.',
        'cust_telp.max_length': 'No. Telp customer maksimal 100 karakter.',
      });

      final customersData = request.input();

      final existingProduct = await model
          .query()
          .where('cust_name', '=', customersData['cust_name'])
          .first();

      if (existingProduct != null) {
        return Response.json(
            {'message': 'Produk dengan nama ini sudah ada.'}, 409);
      }

      // customersData['created_at'] = DateTime.now().toIso8601String();

      await model.query().insert(customersData);

      return Response.json(
        {
          'message': 'Customers berhasil ditambahkan.',
          'data': customersData,
        },
        201,
      );
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json(
          {'errors': errorMessages},
          400,
        );
      } else {
        return Response.json(
          {
            'message':
                'Terjadi kesalahan di sisi server. Harap coba lagi nanti.'
          },
          500,
        );
      }
    }
  }

  Future<Response> show() async {
    try {
      final listCustomers = await model.query().get();
      return Response.json({
        'message': 'Daftar customer.',
        'data': listCustomers,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data customer.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int cust_id) async {
    try {
      request.validate({
        'cust_name': 'required|string|max_length:100',
        'cust_address': 'required|string|max_length:255',
        'cust_city': 'required|string|max_length:255',
        'cust_state': 'required|string|max_length:255',
        'cust_zip': 'required|string|max_length:255',
        'cust_country': 'required|string|max_length:255',
        'cust_telp': 'required|string|max_length:255',
      }, {
        'cust_name.required': 'Nama customer wajib diisi.',
        'cust_name.string': 'Nama customer harus berupa teks.',
        'cust_name.max_length': 'Nama customer maksimal 100 karakter.',
        'cust_addres.required': 'Alamat customer wajib diisi.',
        'cust_addres.string': 'Alamat customer harus berupa teks.',
        'cust_address.max_length': 'Alamat customer maksimal 100 karakter.',
        'cust_city.required': 'Kota customer wajib diisi.',
        'cust_city.string': 'Kota customer harus berupa teks.',
        'cust_city.max_length': 'Kota customer maksimal 100 karakter.',
        'cust_state.required': 'Provinsi customer wajib diisi.',
        'cust_state.string': 'Provinsi customer harus berupa teks.',
        'cust_state.max_length': 'Provinsi customer maksimal 100 karakter.',
        'cust_zip.required': 'Kode pos customer wajib diisi.',
        'cust_zip.string': 'Kode pos customer harus berupa teks.',
        'cust_zip.max_length': 'Kode pos customer maksimal 100 karakter.',
        'cust_country.required': 'Negara customer wajib diisi.',
        'cust_country.string': 'Negara customer harus berupa teks.',
        'cust_country.max_length': 'Negara customer maksimal 100 karakter.',
        'cust_telp.required': 'No. Telp customer wajib diisi.',
        'cust_telp.string': 'No. Telp customer bisa berupa angka.',
        'cust_telp.max_length': 'No. Telp customer maksimal 100 karakter.',
      });

      final customersData = request.input();
      // customersData['updated_at'] = DateTime.now().toIso8601String();

      final customers =
          await model.query().where('cust_id', '=', cust_id).first();

      if (customers == null) {
        return Response.json({
          'message': 'Customer dengan ID $cust_id tidak ditemukan.',
        }, 404);
      }

      await model.query().where('cust_id', '=', cust_id).update(customersData);

      return Response.json({
        'message': 'Customers berhasil diperbarui.',
        'data': customersData,
      }, 200);
    } catch (e) {
      if (e is ValidationException) {
        final errorMessages = e.message;
        return Response.json({'errors': errorMessages}, 400);
      } else {
        return Response.json({
          'message': 'Terjadi kesalahan di sisi server. Harap coba lagi nanti.',
        }, 500);
      }
    }
  }

  Future<Response> destroy(int cust_id) async {
    try {
      final customers =
          await model.query().where('cust_id', '=', cust_id).first();

      if (customers == null) {
        return Response.json({
          'message': 'Customer dengan ID $cust_id tidak ditemukan.',
        }, 404);
      }

      await model.query().where('cust_id', '=', cust_id).delete();

      return Response.json({
        'message': 'Customer berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus customer.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final CustomersController customersController = CustomersController();

import 'package:vania/vania.dart';
import 'package:tugas_backend/app/models/vendors.dart' as VendorsModel;
import 'package:vania/src/exception/validation_exception.dart';

class VendorsController extends Controller {
  final model = VendorsModel.Vendors();
  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  Future<Response> create() async {
    return Response.json({});
  }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'vend_name': 'required|string|max_length:100',
        'vend_address': 'required|string|max_length:255',
        'vend_kota': 'required|string|max_length:255',
        'vend_state': 'required|string|max_length:255',
        'vend_zip': 'required|string|max_length:255',
        'vend_country': 'required|string|max_length:255',
      }, {
        'vend_name.required': 'Nama vendor wajib diisi.',
        'vend_name.string': 'Nama vendor harus berupa teks.',
        'vend_name.max_length': 'Nama vendor maksimal 100 karakter.',
        'vend_address.required': 'Alamat vendor wajib diisi.',
        'vend_address.string': 'Alamat vendor harus berupa teks.',
        'vend_address.max_length': 'Alamat vendor maksimal 100 karakter.',
        'vend_kota.required': 'Kota vendor wajib diisi.',
        'vend_kota.string': 'Kota vendor harus berupa teks.',
        'vend_kota.max_length': 'Kota vendor maksimal 100 karakter.',
        'vend_state.required': 'Provinsi vendor wajib diisi.',
        'vend_state.string': 'Provinsi vendor harus berupa teks.',
        'vend_state.max_length': 'Provinsi vendor maksimal 100 karakter.',
        'vend_zip.required': 'Kode pos vendor wajib diisi.',
        'vend_zip.string': 'Kode pos vendor harus berupa teks.',
        'vend_zip.max_length': 'Kode pos vendor maksimal 100 karakter.',
        'vend_country.required': 'Negara vendor wajib diisi.',
        'vend_country.string': 'Negara vendor harus berupa teks.',
        'vend_country.max_length': 'Negara vendor maksimal 100 karakter.',
      });

      final vendorsData = request.input();

      final existingVendors = await model
          .query()
          .where('vend_name', '=', vendorsData['vend_name'])
          .first();

      if (existingVendors != null) {
        return Response.json(
            {'message': 'Vendor dengan nama ini sudah ada.'}, 409);
      }

      // customersData['created_at'] = DateTime.now().toIso8601String();

      await model.query().insert(vendorsData);

      return Response.json(
        {
          'message': 'Vendor berhasil ditambahkan.',
          'data': vendorsData,
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
      final listVendors = await model.query().get();
      return Response.json({
        'message': 'Daftar vendor.',
        'data': listVendors,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data vendor.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int vend_id) async {
    try {
      request.validate({
        'vend_name': 'required|string|max_length:100',
        'vend_address': 'required|string|max_length:255',
        'vend_kota': 'required|string|max_length:255',
        'vend_state': 'required|string|max_length:255',
        'vend_zip': 'required|string|max_length:255',
        'vend_country': 'required|string|max_length:255',
      }, {
        'vend_name.required': 'Nama vendor wajib diisi.',
        'vend_name.string': 'Nama vendor harus berupa teks.',
        'vend_name.max_length': 'Nama vendor maksimal 100 karakter.',
        'vend_address.required': 'Alamat vendor wajib diisi.',
        'vend_address.string': 'Alamat vendor harus berupa teks.',
        'vend_address.max_length': 'Alamat vendor maksimal 100 karakter.',
        'vend_kota.required': 'Kota vendor wajib diisi.',
        'vend_kota.string': 'Kota vendor harus berupa teks.',
        'vend_kota.max_length': 'Kota vendor maksimal 100 karakter.',
        'vend_state.required': 'Provinsi vendor wajib diisi.',
        'vend_state.string': 'Provinsi vendor harus berupa teks.',
        'vend_state.max_length': 'Provinsi vendor maksimal 100 karakter.',
        'vend_zip.required': 'Kode pos vendor wajib diisi.',
        'vend_zip.string': 'Kode pos vendor harus berupa teks.',
        'vend_zip.max_length': 'Kode pos vendor maksimal 100 karakter.',
        'vend_country.required': 'Negara vendor wajib diisi.',
        'vend_country.string': 'Negara vendor harus berupa teks.',
        'vend_country.max_length': 'Negara vendor maksimal 100 karakter.',
      });

      final vendorsData = request.input();
      // customersData['updated_at'] = DateTime.now().toIso8601String();

      final vendors =
          await model.query().where('vend_id', '=', vend_id).first();

      if (vendors == null) {
        return Response.json({
          'message': 'Vendor dengan ID $vend_id tidak ditemukan.',
        }, 404);
      }

      await model.query().where('vend_id', '=', vend_id).update(vendorsData);

      return Response.json({
        'message': 'Customers berhasil diperbarui.',
        'data': vendorsData,
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

  Future<Response> destroy(int vend_id) async {
    try {
      final vendors =
          await model.query().where('vend_id', '=', vend_id).first();

      if (vendors == null) {
        return Response.json({
          'message': 'Vendor dengan ID $vend_id tidak ditemukan.',
        }, 404);
      }

      await model.query().where('vend_id', '=', vend_id).delete();

      return Response.json({
        'message': 'Vendor berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus Vendor.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final VendorsController vendorsController = VendorsController();

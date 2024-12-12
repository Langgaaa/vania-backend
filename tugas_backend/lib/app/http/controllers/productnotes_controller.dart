import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:tugas_backend/app/models/productnotes.dart'
    as ProductnotessModel;

class ProductnotesController extends Controller {
  final model = ProductnotessModel.Productnotes();

  Future<Response> index() async {
    return Response.json({'message': 'Hello World'});
  }

  // Future<Response> create(Request request) async {
  //   request.validate({
  //     'name': 'required',
  //     'description': 'required',
  //     'price': 'required',
  //   }, {
  //     'name.required': 'Nama tidak boleh kosong',
  //     'description.required': 'Description tidak boleh kosong',
  //     'price.required': 'Price tidak boleh kosong',
  //   });

  //   try {
  //     final requestData = request.input();
  //     return Response.json(
  //         {'message': 'Product created successfully', 'data': requestData},
  //         201);
  //   } catch (e) {
  //     return Response.json(
  //         {'message': 'Error creating product', 'error': e.toString()}, 500);
  //   }
  // }

  Future<Response> store(Request request) async {
    try {
      request.validate({
        'note_text': 'required|string|max_length:500',
      }, {
        'note_text.required': ' note text wajib diisi.',
        'note_text.string': 'note text harus berupa angka.',
        'note_text.max_length': 'note text maksimal 500 karakter.',
      });
      final productnotesData = request.input();

      final existingProductnotes = await model
          .query()
          .where('note_text', '=', productnotesData['note_text'])
          .first();

      if (existingProductnotes != null) {
        return Response.json({'message': 'Null.'}, 409);
      }

      productnotesData['note_date'] = DateTime.now().toIso8601String();

      await model.query().insert(productnotesData);

      return Response.json(
        {
          'message': 'order item berhasil ditambahkan.',
          'data': productnotesData,
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
      final listProductnotes = await model.query().get();
      return Response.json({
        'message': 'Daftar product notes.',
        'data': listProductnotes,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order item.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int note_id) async {
    try {
      request.validate({
        'note_text': 'required|string|max_length:500',
      }, {
        'note_text.required': ' note text wajib diisi.',
        'note_text.string': 'note text harus berupa angka.',
        'note_text.max_length': 'note text maksimal 500 karakter.',
      });

      final productnotesData = request.input();
      // productData['updated_at'] = DateTime.now().toIso8601String();

      final productnotes =
          await model.query().where('note_id', '=', note_id).first();

      if (productnotes == null) {
        return Response.json({
          'message': 'Produk dengan ID $note_id tidak ditemukan.',
        }, 404);
      }

      await model
          .query()
          .where('note_id', '=', note_id)
          .update(productnotesData);

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': productnotesData,
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

  Future<Response> destroy(int note_id) async {
    try {
      final productnotes =
          await model.query().where('note_id', '=', note_id).first();

      if (productnotes == null) {
        return Response.json({
          'message': 'Produk dengan ID $note_id tidak ditemukan.',
        }, 404);
      }

      await model.query().where('note_id', '=', note_id).delete();

      return Response.json({
        'message': 'Produk berhasil dihapus.',
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat menghapus produk.',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductnotesController productnotesController = ProductnotesController();

import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:tugas_backend/app/models/orderitems.dart' as OrderitemsModel;

class OrderitemsController extends Controller {
  final model = OrderitemsModel.Orderitems();

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
        'quantity': 'required|int|max_length:100',
        'size': 'required|int|max_length:255',
      }, {
        'quantity.required': ' quantity wajib diisi.',
        'quantity.int': 'quantity harus berupa angka.',
        'quantity.max_length': 'quantity maksimal 100 karakter.',
        'size.required': 'size produk wajib diisi.',
        'size.int': 'size produk harus berupa angka.',
        'size.max_length': 'size produk maksimal 255 karakter.',
      });
      final orderitemsData = request.input();

      final existingOrderitems = await model
          .query()
          .where('quantity', '=', orderitemsData['quantity'])
          .first();

      if (existingOrderitems != null) {
        return Response.json({'message': 'Null.'}, 409);
      }

      // productsData['created_at'] = DateTime.now().toIso8601String();

      await model.query().insert(orderitemsData);

      return Response.json(
        {
          'message': 'order item berhasil ditambahkan.',
          'data': orderitemsData,
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
      final listOrderitems = await model.query().get();
      return Response.json({
        'message': 'Daftar order.',
        'data': listOrderitems,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order item.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int order_item) async {
    try {
      request.validate({
        'quantity': 'required|int|max_length:100',
        'size': 'required|int|max_length:255',
      }, {
        'quantity.required': ' quantity wajib diisi.',
        'quantity.int': 'quantity harus berupa angka.',
        'quantity.max_length': 'quantity maksimal 100 karakter.',
        'size.required': 'size produk wajib diisi.',
        'size.int': 'size produk harus berupa angka.',
        'size.max_length': 'size produk maksimal 255 karakter.',
      });

      final orderitemsData = request.input();
      // productData['updated_at'] = DateTime.now().toIso8601String();

      final orderitems =
          await model.query().where('order_item', '=', order_item).first();

      if (orderitems == null) {
        return Response.json({
          'message': 'Produk dengan ID $order_item tidak ditemukan.',
        }, 404);
      }

      await model
          .query()
          .where('order_item', '=', order_item)
          .update(orderitemsData);

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': orderitemsData,
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

  Future<Response> destroy(int order_item) async {
    try {
      final orderitems =
          await model.query().where('order_item', '=', order_item).first();

      if (orderitems == null) {
        return Response.json({
          'message': 'Produk dengan ID $order_item tidak ditemukan.',
        }, 404);
      }

      await model.query().where('order_item', '=', order_item).delete();

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

final OrderitemsController orderitemsController = OrderitemsController();

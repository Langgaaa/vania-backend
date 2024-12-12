import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:tugas_backend/app/models/orders.dart' as OrdersModel;

class OrdersController extends Controller {
  final model = OrdersModel.Orders();

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
      // request.validate({
      //   'order_date': 'required',
      //   'size': 'required|int|max_length:255',
      // }, {
      //   'quantity.required': ' quantity wajib diisi.',
      //   'quantity.int': 'quantity harus berupa angka.',
      //   'quantity.max_length': 'quantity maksimal 100 karakter.',
      //   'size.required': 'size produk wajib diisi.',
      //   'size.int': 'size produk harus berupa angka.',
      //   'size.max_length': 'size produk maksimal 255 karakter.',
      // );
      final ordersData = request.input();

      // final existingOrders = await model
      //     .query()
      //     .where('order_date', '=', ordersData['order_date'])
      //     .first();

      // if (existingOrders != null) {
      //   return Response.json({'message': 'Null.'}, 409);
      // }

      ordersData['order_date'] = DateTime.now().toIso8601String();

      // await model.query().insert(orderitemsData);

      return Response.json(
        {
          'message': 'order item berhasil ditambahkan.',
          'data': ordersData,
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
      final listOrders = await model.query().get();
      return Response.json({
        'message': 'Daftar order.',
        'data': listOrders,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data order item.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int order_num) async {
    try {
      // request.validate({
      //   'order_date': 'required',
      //   'size': 'required|int|max_length:255',
      // }, {
      //   'quantity.required': ' quantity wajib diisi.',
      //   'quantity.int': 'quantity harus berupa angka.',
      //   'quantity.max_length': 'quantity maksimal 100 karakter.',
      //   'size.required': 'size produk wajib diisi.',
      //   'size.int': 'size produk harus berupa angka.',
      //   'size.max_length': 'size produk maksimal 255 karakter.',
      // );
      final ordersData = request.input();

      final existingOrders = await model
          .query()
          .where('order_num', '=', ordersData['order_num'])
          .first();

      if (existingOrders != null) {
        return Response.json({'message': 'Null.'}, 409);
      }

      ordersData['order_date'] = DateTime.now().toIso8601String();

      // await model.query().insert(orderitemsData);

      final orders =
          await model.query().where('order_num', '=', order_num).first();

      if (orders == null) {
        return Response.json({
          'message': 'Produk dengan ID $order_num tidak ditemukan.',
        }, 404);
      }

      await model
          .query()
          .where('order_item', '=', order_num)
          .update(ordersData);

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': ordersData,
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

  Future<Response> destroy(int order_num) async {
    try {
      final orders =
          await model.query().where('order_num', '=', order_num).first();

      if (orders == null) {
        return Response.json({
          'message': 'Produk dengan ID $order_num tidak ditemukan.',
        }, 404);
      }

      await model.query().where('order_num', '=', order_num).delete();

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

final OrdersController ordersController = OrdersController();

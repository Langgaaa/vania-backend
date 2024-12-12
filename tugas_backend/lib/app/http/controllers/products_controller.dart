import 'package:vania/vania.dart';
import 'package:vania/src/exception/validation_exception.dart';
import 'package:tugas_backend/app/models/products.dart' as ProductsModel;

class ProductsController extends Controller {
  final model = ProductsModel.Products();

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
        'prod_name': 'required|string|max_length:100',
        'prod_desc': 'required|string|max_length:255',
        'prod_price': 'required|numeric|min:0',
      }, {
        'prod_name.required': 'Nama produk wajib diisi.',
        'prod_name.string': 'Nama produk harus berupa teks.',
        'prod_name.max_length': 'Nama produk maksimal 100 karakter.',
        'prod_desc.required': 'Deskripsi produk wajib diisi.',
        'prod_desc.string': 'Deskripsi produk harus berupa teks.',
        'prod_desc.max_length': 'Deskripsi produk maksimal 255 karakter.',
        'prod_price.required': 'Harga produk wajib diisi.',
        'prod_price.numeric': 'Harga produk harus berupa angka.',
        'prod_price.min': 'Harga produk tidak boleh kurang dari 0.',
      });
      final productsData = request.input();

      final existingProducts = await model
          .query()
          .where('prod_name', '=', productsData['prod_name'])
          .first();

      if (existingProducts != null) {
        return Response.json(
            {'message': 'Produk dengan nama ini sudah ada.'}, 409);
      }

      // productsData['created_at'] = DateTime.now().toIso8601String();

      await model.query().insert(productsData);

      return Response.json(
        {
          'message': 'Produk berhasil ditambahkan.',
          'data': productsData,
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
      final listProducts = await model.query().get();
      return Response.json({
        'message': 'Daftar produk.',
        'data': listProducts,
      }, 200);
    } catch (e) {
      return Response.json({
        'message': 'Terjadi kesalahan saat mengambil data produk.',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int prod_id) async {
    try {
      request.validate({
        'prod_name': 'required|string|max_length:100',
        'prod_desc': 'required|string|max_length:255',
        'prod_price': 'required|numeric|min:0',
      }, {
        'prod_name.required': 'Nama produk wajib diisi.',
        'prod_name.string': 'Nama produk harus berupa teks.',
        'prod_name.max_length': 'Nama produk maksimal 100 karakter.',
        'prod_desc.required': 'Deskripsi produk wajib diisi.',
        'prod_desc.string': 'Deskripsi produk harus berupa teks.',
        'prod_desc.max_length': 'Deskripsi produk maksimal 255 karakter.',
        'prod_price.required': 'Harga produk wajib diisi.',
        'prod_price.numeric': 'Harga produk harus berupa angka.',
        'prod_price.min': 'Harga produk tidak boleh kurang dari 0.',
      });

      final productsData = request.input();
      // productData['updated_at'] = DateTime.now().toIso8601String();

      final products =
          await model.query().where('prod_id', '=', prod_id).first();

      if (products == null) {
        return Response.json({
          'message': 'Produk dengan ID $prod_id tidak ditemukan.',
        }, 404);
      }

      await model.query().where('prod_id', '=', prod_id).update(productsData);

      return Response.json({
        'message': 'Produk berhasil diperbarui.',
        'data': productsData,
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

  Future<Response> destroy(int prod_id) async {
    try {
      final products =
          await model.query().where('prod_id', '=', prod_id).first();

      if (products == null) {
        return Response.json({
          'message': 'Produk dengan ID $prod_id tidak ditemukan.',
        }, 404);
      }

      await model.query().where('prod_id', '=', prod_id).delete();

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

final ProductsController productsController = ProductsController();

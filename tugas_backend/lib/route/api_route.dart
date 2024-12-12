import 'package:tugas_backend/app/http/controllers/orderitems_controller.dart';
import 'package:tugas_backend/app/http/controllers/orders_controller.dart';
import 'package:tugas_backend/app/http/controllers/product.dart';
import 'package:tugas_backend/app/http/controllers/productnotes_controller.dart';
import 'package:tugas_backend/app/http/controllers/products_controller.dart';
import 'package:tugas_backend/app/http/controllers/vendors_controller.dart';
import 'package:vania/vania.dart';
import 'package:tugas_backend/app/http/controllers/home_controller.dart';
import 'package:tugas_backend/app/http/middleware/authenticate.dart';
import 'package:tugas_backend/app/http/middleware/home_middleware.dart';
import 'package:tugas_backend/app/http/middleware/error_response_middleware.dart';
import 'package:tugas_backend/app/http/controllers/customers_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    //Product
    Router.post('/products', productsController.store);
    Router.get('/products', productsController.show);
    Router.put('/products/{prod_id}', productsController.update);
    Router.delete('/products/{prod_id}', productsController.destroy);

    //Customer
    Router.post('/customers', customersController.store);
    Router.get('/customers', customersController.show);
    Router.put('/customers/{cust_id}', customersController.update);
    Router.delete('/customers/{cust_id}', customersController.destroy);

    //Vendor
    Router.post('/vendors', vendorsController.store);
    Router.get('/vendors', vendorsController.show);
    Router.put('/vendors/{vend_id}', vendorsController.update);
    Router.delete('/vendors/{vend_id}', vendorsController.destroy);

    //Order Items
    Router.post('/orderitems', orderitemsController.store);
    Router.get('/orderitems', orderitemsController.show);
    Router.put('/orderitems/{order_item}', orderitemsController.update);
    Router.delete('/orderitems/{order_item}', orderitemsController.destroy);

    //Order Items
    Router.post('/productnotes', productnotesController.store);
    Router.get('/productnotes', productnotesController.show);
    Router.put('/productnotes/{note_id}', productnotesController.update);
    Router.delete('/productnotes/{note_id}', productnotesController.destroy);

    //Order Items
    Router.post('/orders', ordersController.store);
    Router.get('/orders', ordersController.show);
    Router.put('/orders/{order_num}', ordersController.update);
    Router.delete('/orders/{order_num}', ordersController.destroy);
  }
}

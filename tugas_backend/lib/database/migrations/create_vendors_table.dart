import 'package:vania/vania.dart';

class CreateVendorsTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('vendors', () {
      id();
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('vendors');
  }
}

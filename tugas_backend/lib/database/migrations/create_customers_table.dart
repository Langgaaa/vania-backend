import 'package:vania/vania.dart';

class CreateCustomersTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('customers', () {
      id();
      timeStamps();
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('customers');
  }
}

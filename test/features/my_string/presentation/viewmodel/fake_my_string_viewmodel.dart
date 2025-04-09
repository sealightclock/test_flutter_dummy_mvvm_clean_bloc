import 'package:flutter_test/flutter_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/presentation/viewmodel/my_string_viewmodel.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/my_string/domain/entity/my_string_entity.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/util/result.dart';

class FakeMyStringViewModel extends Fake implements MyStringViewModel {
  @override
  Future<Result<MyStringEntity>> getMyStringFromLocal() async {
    return Success(MyStringEntity(value: ''));
  }

// Optional: stub other methods if needed
}

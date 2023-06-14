import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'ride_state.dart';

class RideCubit extends Cubit<RideState> {
  RideCubit() : super(RideInitial());
}

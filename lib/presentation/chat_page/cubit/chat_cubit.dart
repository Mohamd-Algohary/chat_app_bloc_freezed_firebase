import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '/domain/usecase/get_message_usecase.dart';
import '../../../domain/model/model.dart';
import '../../../domain/usecase/send_message_usecase.dart';

part 'chat_state.dart';
part 'chat_cubit.freezed.dart';

class ChatCubit extends Cubit<ChatState> {
  final SendMessageUSecase _sendUseCase;
  final GetMessageUSecase _getUseCase;
  CollectionReference messages;
  ChatCubit(this._sendUseCase, this._getUseCase, this.messages)
      : super(const ChatState.loading());

  void sendMessage({required String message, required String email}) async {
    emit(const ChatState.loading());
    (await _sendUseCase.excute(Message(message, email))).fold((failure) {
      emit(ChatState.error(failure.message));
    }, (messageId) {});
  }

  void getMessages() async {
    emit(const ChatState.loading());
    (await _getUseCase.excute("")).fold((failure) {
      emit(ChatState.error(failure.message));
    }, (messagesList) {
      emit(ChatState.success(messagesList));
    });
  }

  void initChatListner() {
    messages.snapshots().listen(
      (_) {
        getMessages();
      },
    );
  }
}

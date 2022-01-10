// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slideparty_button_params.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ButtonColorsAdapter extends TypeAdapter<ButtonColors> {
  @override
  final int typeId = 0;

  @override
  ButtonColors read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ButtonColors.blue;
      case 1:
        return ButtonColors.green;
      case 2:
        return ButtonColors.red;
      case 3:
        return ButtonColors.yellow;
      default:
        return ButtonColors.blue;
    }
  }

  @override
  void write(BinaryWriter writer, ButtonColors obj) {
    switch (obj) {
      case ButtonColors.blue:
        writer.writeByte(0);
        break;
      case ButtonColors.green:
        writer.writeByte(1);
        break;
      case ButtonColors.red:
        writer.writeByte(2);
        break;
      case ButtonColors.yellow:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ButtonColorsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

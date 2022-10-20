import 'package:particle_wallet_example/generated/json/base/json_convert_content.dart';
import 'package:particle_wallet_example/model/d_app_metadata_entity.dart';

DAppMetadataEntity $DAppMetadataEntityFromJson(Map<String, dynamic> json) {
	final DAppMetadataEntity dAppMetadataEntity = DAppMetadataEntity();
	final String? name = jsonConvert.convert<String>(json['name']);
	if (name != null) {
		dAppMetadataEntity.name = name;
	}
	final String? icon = jsonConvert.convert<String>(json['icon']);
	if (icon != null) {
		dAppMetadataEntity.icon = icon;
	}
	final String? url = jsonConvert.convert<String>(json['url']);
	if (url != null) {
		dAppMetadataEntity.url = url;
	}
	return dAppMetadataEntity;
}

Map<String, dynamic> $DAppMetadataEntityToJson(DAppMetadataEntity entity) {
	final Map<String, dynamic> data = <String, dynamic>{};
	data['name'] = entity.name;
	data['icon'] = entity.icon;
	data['url'] = entity.url;
	return data;
}
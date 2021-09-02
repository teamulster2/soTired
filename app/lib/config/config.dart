/// This [abstract class] defines methods / constructors for all Config classes.
abstract class Config {
  Config._fromJson();
  Map<String, dynamic> toJson();
}

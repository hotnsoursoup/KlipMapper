// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReportData {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReportData()';
}


}

/// @nodoc
class $ReportDataCopyWith<$Res>  {
$ReportDataCopyWith(ReportData _, $Res Function(ReportData) __);
}


/// Adds pattern-matching-related methods to [ReportData].
extension ReportDataPatterns on ReportData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RevenueReportData value)?  revenue,TResult Function( ServicePerformanceReportData value)?  servicePerformance,TResult Function( TechnicianPerformanceReportData value)?  technicianPerformance,TResult Function( CustomerAnalyticsReportData value)?  customerAnalytics,TResult Function( AppointmentAnalyticsReportData value)?  appointmentAnalytics,TResult Function( PaymentAnalyticsReportData value)?  paymentAnalytics,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RevenueReportData() when revenue != null:
return revenue(_that);case ServicePerformanceReportData() when servicePerformance != null:
return servicePerformance(_that);case TechnicianPerformanceReportData() when technicianPerformance != null:
return technicianPerformance(_that);case CustomerAnalyticsReportData() when customerAnalytics != null:
return customerAnalytics(_that);case AppointmentAnalyticsReportData() when appointmentAnalytics != null:
return appointmentAnalytics(_that);case PaymentAnalyticsReportData() when paymentAnalytics != null:
return paymentAnalytics(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RevenueReportData value)  revenue,required TResult Function( ServicePerformanceReportData value)  servicePerformance,required TResult Function( TechnicianPerformanceReportData value)  technicianPerformance,required TResult Function( CustomerAnalyticsReportData value)  customerAnalytics,required TResult Function( AppointmentAnalyticsReportData value)  appointmentAnalytics,required TResult Function( PaymentAnalyticsReportData value)  paymentAnalytics,}){
final _that = this;
switch (_that) {
case RevenueReportData():
return revenue(_that);case ServicePerformanceReportData():
return servicePerformance(_that);case TechnicianPerformanceReportData():
return technicianPerformance(_that);case CustomerAnalyticsReportData():
return customerAnalytics(_that);case AppointmentAnalyticsReportData():
return appointmentAnalytics(_that);case PaymentAnalyticsReportData():
return paymentAnalytics(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RevenueReportData value)?  revenue,TResult? Function( ServicePerformanceReportData value)?  servicePerformance,TResult? Function( TechnicianPerformanceReportData value)?  technicianPerformance,TResult? Function( CustomerAnalyticsReportData value)?  customerAnalytics,TResult? Function( AppointmentAnalyticsReportData value)?  appointmentAnalytics,TResult? Function( PaymentAnalyticsReportData value)?  paymentAnalytics,}){
final _that = this;
switch (_that) {
case RevenueReportData() when revenue != null:
return revenue(_that);case ServicePerformanceReportData() when servicePerformance != null:
return servicePerformance(_that);case TechnicianPerformanceReportData() when technicianPerformance != null:
return technicianPerformance(_that);case CustomerAnalyticsReportData() when customerAnalytics != null:
return customerAnalytics(_that);case AppointmentAnalyticsReportData() when appointmentAnalytics != null:
return appointmentAnalytics(_that);case PaymentAnalyticsReportData() when paymentAnalytics != null:
return paymentAnalytics(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( double totalRevenue,  double todayRevenue,  double yesterdayRevenue,  double weekRevenue,  double monthRevenue,  List<DailyRevenue> dailyData,  List<ServiceRevenue> topServices)?  revenue,TResult Function( List<ServiceMetrics> serviceMetrics,  int totalServicesCompleted,  double averageServiceValue,  List<ServiceTrend> trends)?  servicePerformance,TResult Function( List<TechnicianMetrics> technicianMetrics,  int totalAppointments,  double averageRating,  List<TechnicianRevenue> revenueByTechnician)?  technicianPerformance,TResult Function( int totalCustomers,  int newCustomersThisMonth,  int returningCustomers,  double averageVisitValue,  List<CustomerSegment> segments,  List<CustomerRetention> retentionData)?  customerAnalytics,TResult Function( int totalAppointments,  int completedAppointments,  int cancelledAppointments,  double showUpRate,  List<HourlyBooking> bookingPatterns,  List<AppointmentType> typeDistribution)?  appointmentAnalytics,TResult Function( double totalPayments,  Map<String, double> paymentMethodBreakdown,  double averageTransactionAmount,  List<PaymentTrend> trends,  double tipsTotal)?  paymentAnalytics,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RevenueReportData() when revenue != null:
return revenue(_that.totalRevenue,_that.todayRevenue,_that.yesterdayRevenue,_that.weekRevenue,_that.monthRevenue,_that.dailyData,_that.topServices);case ServicePerformanceReportData() when servicePerformance != null:
return servicePerformance(_that.serviceMetrics,_that.totalServicesCompleted,_that.averageServiceValue,_that.trends);case TechnicianPerformanceReportData() when technicianPerformance != null:
return technicianPerformance(_that.technicianMetrics,_that.totalAppointments,_that.averageRating,_that.revenueByTechnician);case CustomerAnalyticsReportData() when customerAnalytics != null:
return customerAnalytics(_that.totalCustomers,_that.newCustomersThisMonth,_that.returningCustomers,_that.averageVisitValue,_that.segments,_that.retentionData);case AppointmentAnalyticsReportData() when appointmentAnalytics != null:
return appointmentAnalytics(_that.totalAppointments,_that.completedAppointments,_that.cancelledAppointments,_that.showUpRate,_that.bookingPatterns,_that.typeDistribution);case PaymentAnalyticsReportData() when paymentAnalytics != null:
return paymentAnalytics(_that.totalPayments,_that.paymentMethodBreakdown,_that.averageTransactionAmount,_that.trends,_that.tipsTotal);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( double totalRevenue,  double todayRevenue,  double yesterdayRevenue,  double weekRevenue,  double monthRevenue,  List<DailyRevenue> dailyData,  List<ServiceRevenue> topServices)  revenue,required TResult Function( List<ServiceMetrics> serviceMetrics,  int totalServicesCompleted,  double averageServiceValue,  List<ServiceTrend> trends)  servicePerformance,required TResult Function( List<TechnicianMetrics> technicianMetrics,  int totalAppointments,  double averageRating,  List<TechnicianRevenue> revenueByTechnician)  technicianPerformance,required TResult Function( int totalCustomers,  int newCustomersThisMonth,  int returningCustomers,  double averageVisitValue,  List<CustomerSegment> segments,  List<CustomerRetention> retentionData)  customerAnalytics,required TResult Function( int totalAppointments,  int completedAppointments,  int cancelledAppointments,  double showUpRate,  List<HourlyBooking> bookingPatterns,  List<AppointmentType> typeDistribution)  appointmentAnalytics,required TResult Function( double totalPayments,  Map<String, double> paymentMethodBreakdown,  double averageTransactionAmount,  List<PaymentTrend> trends,  double tipsTotal)  paymentAnalytics,}) {final _that = this;
switch (_that) {
case RevenueReportData():
return revenue(_that.totalRevenue,_that.todayRevenue,_that.yesterdayRevenue,_that.weekRevenue,_that.monthRevenue,_that.dailyData,_that.topServices);case ServicePerformanceReportData():
return servicePerformance(_that.serviceMetrics,_that.totalServicesCompleted,_that.averageServiceValue,_that.trends);case TechnicianPerformanceReportData():
return technicianPerformance(_that.technicianMetrics,_that.totalAppointments,_that.averageRating,_that.revenueByTechnician);case CustomerAnalyticsReportData():
return customerAnalytics(_that.totalCustomers,_that.newCustomersThisMonth,_that.returningCustomers,_that.averageVisitValue,_that.segments,_that.retentionData);case AppointmentAnalyticsReportData():
return appointmentAnalytics(_that.totalAppointments,_that.completedAppointments,_that.cancelledAppointments,_that.showUpRate,_that.bookingPatterns,_that.typeDistribution);case PaymentAnalyticsReportData():
return paymentAnalytics(_that.totalPayments,_that.paymentMethodBreakdown,_that.averageTransactionAmount,_that.trends,_that.tipsTotal);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( double totalRevenue,  double todayRevenue,  double yesterdayRevenue,  double weekRevenue,  double monthRevenue,  List<DailyRevenue> dailyData,  List<ServiceRevenue> topServices)?  revenue,TResult? Function( List<ServiceMetrics> serviceMetrics,  int totalServicesCompleted,  double averageServiceValue,  List<ServiceTrend> trends)?  servicePerformance,TResult? Function( List<TechnicianMetrics> technicianMetrics,  int totalAppointments,  double averageRating,  List<TechnicianRevenue> revenueByTechnician)?  technicianPerformance,TResult? Function( int totalCustomers,  int newCustomersThisMonth,  int returningCustomers,  double averageVisitValue,  List<CustomerSegment> segments,  List<CustomerRetention> retentionData)?  customerAnalytics,TResult? Function( int totalAppointments,  int completedAppointments,  int cancelledAppointments,  double showUpRate,  List<HourlyBooking> bookingPatterns,  List<AppointmentType> typeDistribution)?  appointmentAnalytics,TResult? Function( double totalPayments,  Map<String, double> paymentMethodBreakdown,  double averageTransactionAmount,  List<PaymentTrend> trends,  double tipsTotal)?  paymentAnalytics,}) {final _that = this;
switch (_that) {
case RevenueReportData() when revenue != null:
return revenue(_that.totalRevenue,_that.todayRevenue,_that.yesterdayRevenue,_that.weekRevenue,_that.monthRevenue,_that.dailyData,_that.topServices);case ServicePerformanceReportData() when servicePerformance != null:
return servicePerformance(_that.serviceMetrics,_that.totalServicesCompleted,_that.averageServiceValue,_that.trends);case TechnicianPerformanceReportData() when technicianPerformance != null:
return technicianPerformance(_that.technicianMetrics,_that.totalAppointments,_that.averageRating,_that.revenueByTechnician);case CustomerAnalyticsReportData() when customerAnalytics != null:
return customerAnalytics(_that.totalCustomers,_that.newCustomersThisMonth,_that.returningCustomers,_that.averageVisitValue,_that.segments,_that.retentionData);case AppointmentAnalyticsReportData() when appointmentAnalytics != null:
return appointmentAnalytics(_that.totalAppointments,_that.completedAppointments,_that.cancelledAppointments,_that.showUpRate,_that.bookingPatterns,_that.typeDistribution);case PaymentAnalyticsReportData() when paymentAnalytics != null:
return paymentAnalytics(_that.totalPayments,_that.paymentMethodBreakdown,_that.averageTransactionAmount,_that.trends,_that.tipsTotal);case _:
  return null;

}
}

}

/// @nodoc


class RevenueReportData implements ReportData {
  const RevenueReportData({required this.totalRevenue, required this.todayRevenue, required this.yesterdayRevenue, required this.weekRevenue, required this.monthRevenue, required final  List<DailyRevenue> dailyData, required final  List<ServiceRevenue> topServices}): _dailyData = dailyData,_topServices = topServices;
  

 final  double totalRevenue;
 final  double todayRevenue;
 final  double yesterdayRevenue;
 final  double weekRevenue;
 final  double monthRevenue;
 final  List<DailyRevenue> _dailyData;
 List<DailyRevenue> get dailyData {
  if (_dailyData is EqualUnmodifiableListView) return _dailyData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyData);
}

 final  List<ServiceRevenue> _topServices;
 List<ServiceRevenue> get topServices {
  if (_topServices is EqualUnmodifiableListView) return _topServices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topServices);
}


/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevenueReportDataCopyWith<RevenueReportData> get copyWith => _$RevenueReportDataCopyWithImpl<RevenueReportData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RevenueReportData&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.todayRevenue, todayRevenue) || other.todayRevenue == todayRevenue)&&(identical(other.yesterdayRevenue, yesterdayRevenue) || other.yesterdayRevenue == yesterdayRevenue)&&(identical(other.weekRevenue, weekRevenue) || other.weekRevenue == weekRevenue)&&(identical(other.monthRevenue, monthRevenue) || other.monthRevenue == monthRevenue)&&const DeepCollectionEquality().equals(other._dailyData, _dailyData)&&const DeepCollectionEquality().equals(other._topServices, _topServices));
}


@override
int get hashCode => Object.hash(runtimeType,totalRevenue,todayRevenue,yesterdayRevenue,weekRevenue,monthRevenue,const DeepCollectionEquality().hash(_dailyData),const DeepCollectionEquality().hash(_topServices));

@override
String toString() {
  return 'ReportData.revenue(totalRevenue: $totalRevenue, todayRevenue: $todayRevenue, yesterdayRevenue: $yesterdayRevenue, weekRevenue: $weekRevenue, monthRevenue: $monthRevenue, dailyData: $dailyData, topServices: $topServices)';
}


}

/// @nodoc
abstract mixin class $RevenueReportDataCopyWith<$Res> implements $ReportDataCopyWith<$Res> {
  factory $RevenueReportDataCopyWith(RevenueReportData value, $Res Function(RevenueReportData) _then) = _$RevenueReportDataCopyWithImpl;
@useResult
$Res call({
 double totalRevenue, double todayRevenue, double yesterdayRevenue, double weekRevenue, double monthRevenue, List<DailyRevenue> dailyData, List<ServiceRevenue> topServices
});




}
/// @nodoc
class _$RevenueReportDataCopyWithImpl<$Res>
    implements $RevenueReportDataCopyWith<$Res> {
  _$RevenueReportDataCopyWithImpl(this._self, this._then);

  final RevenueReportData _self;
  final $Res Function(RevenueReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? totalRevenue = null,Object? todayRevenue = null,Object? yesterdayRevenue = null,Object? weekRevenue = null,Object? monthRevenue = null,Object? dailyData = null,Object? topServices = null,}) {
  return _then(RevenueReportData(
totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,todayRevenue: null == todayRevenue ? _self.todayRevenue : todayRevenue // ignore: cast_nullable_to_non_nullable
as double,yesterdayRevenue: null == yesterdayRevenue ? _self.yesterdayRevenue : yesterdayRevenue // ignore: cast_nullable_to_non_nullable
as double,weekRevenue: null == weekRevenue ? _self.weekRevenue : weekRevenue // ignore: cast_nullable_to_non_nullable
as double,monthRevenue: null == monthRevenue ? _self.monthRevenue : monthRevenue // ignore: cast_nullable_to_non_nullable
as double,dailyData: null == dailyData ? _self._dailyData : dailyData // ignore: cast_nullable_to_non_nullable
as List<DailyRevenue>,topServices: null == topServices ? _self._topServices : topServices // ignore: cast_nullable_to_non_nullable
as List<ServiceRevenue>,
  ));
}


}

/// @nodoc


class ServicePerformanceReportData implements ReportData {
  const ServicePerformanceReportData({required final  List<ServiceMetrics> serviceMetrics, required this.totalServicesCompleted, required this.averageServiceValue, required final  List<ServiceTrend> trends}): _serviceMetrics = serviceMetrics,_trends = trends;
  

 final  List<ServiceMetrics> _serviceMetrics;
 List<ServiceMetrics> get serviceMetrics {
  if (_serviceMetrics is EqualUnmodifiableListView) return _serviceMetrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_serviceMetrics);
}

 final  int totalServicesCompleted;
 final  double averageServiceValue;
 final  List<ServiceTrend> _trends;
 List<ServiceTrend> get trends {
  if (_trends is EqualUnmodifiableListView) return _trends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trends);
}


/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServicePerformanceReportDataCopyWith<ServicePerformanceReportData> get copyWith => _$ServicePerformanceReportDataCopyWithImpl<ServicePerformanceReportData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServicePerformanceReportData&&const DeepCollectionEquality().equals(other._serviceMetrics, _serviceMetrics)&&(identical(other.totalServicesCompleted, totalServicesCompleted) || other.totalServicesCompleted == totalServicesCompleted)&&(identical(other.averageServiceValue, averageServiceValue) || other.averageServiceValue == averageServiceValue)&&const DeepCollectionEquality().equals(other._trends, _trends));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_serviceMetrics),totalServicesCompleted,averageServiceValue,const DeepCollectionEquality().hash(_trends));

@override
String toString() {
  return 'ReportData.servicePerformance(serviceMetrics: $serviceMetrics, totalServicesCompleted: $totalServicesCompleted, averageServiceValue: $averageServiceValue, trends: $trends)';
}


}

/// @nodoc
abstract mixin class $ServicePerformanceReportDataCopyWith<$Res> implements $ReportDataCopyWith<$Res> {
  factory $ServicePerformanceReportDataCopyWith(ServicePerformanceReportData value, $Res Function(ServicePerformanceReportData) _then) = _$ServicePerformanceReportDataCopyWithImpl;
@useResult
$Res call({
 List<ServiceMetrics> serviceMetrics, int totalServicesCompleted, double averageServiceValue, List<ServiceTrend> trends
});




}
/// @nodoc
class _$ServicePerformanceReportDataCopyWithImpl<$Res>
    implements $ServicePerformanceReportDataCopyWith<$Res> {
  _$ServicePerformanceReportDataCopyWithImpl(this._self, this._then);

  final ServicePerformanceReportData _self;
  final $Res Function(ServicePerformanceReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? serviceMetrics = null,Object? totalServicesCompleted = null,Object? averageServiceValue = null,Object? trends = null,}) {
  return _then(ServicePerformanceReportData(
serviceMetrics: null == serviceMetrics ? _self._serviceMetrics : serviceMetrics // ignore: cast_nullable_to_non_nullable
as List<ServiceMetrics>,totalServicesCompleted: null == totalServicesCompleted ? _self.totalServicesCompleted : totalServicesCompleted // ignore: cast_nullable_to_non_nullable
as int,averageServiceValue: null == averageServiceValue ? _self.averageServiceValue : averageServiceValue // ignore: cast_nullable_to_non_nullable
as double,trends: null == trends ? _self._trends : trends // ignore: cast_nullable_to_non_nullable
as List<ServiceTrend>,
  ));
}


}

/// @nodoc


class TechnicianPerformanceReportData implements ReportData {
  const TechnicianPerformanceReportData({required final  List<TechnicianMetrics> technicianMetrics, required this.totalAppointments, required this.averageRating, required final  List<TechnicianRevenue> revenueByTechnician}): _technicianMetrics = technicianMetrics,_revenueByTechnician = revenueByTechnician;
  

 final  List<TechnicianMetrics> _technicianMetrics;
 List<TechnicianMetrics> get technicianMetrics {
  if (_technicianMetrics is EqualUnmodifiableListView) return _technicianMetrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_technicianMetrics);
}

 final  int totalAppointments;
 final  double averageRating;
 final  List<TechnicianRevenue> _revenueByTechnician;
 List<TechnicianRevenue> get revenueByTechnician {
  if (_revenueByTechnician is EqualUnmodifiableListView) return _revenueByTechnician;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_revenueByTechnician);
}


/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianPerformanceReportDataCopyWith<TechnicianPerformanceReportData> get copyWith => _$TechnicianPerformanceReportDataCopyWithImpl<TechnicianPerformanceReportData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianPerformanceReportData&&const DeepCollectionEquality().equals(other._technicianMetrics, _technicianMetrics)&&(identical(other.totalAppointments, totalAppointments) || other.totalAppointments == totalAppointments)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&const DeepCollectionEquality().equals(other._revenueByTechnician, _revenueByTechnician));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_technicianMetrics),totalAppointments,averageRating,const DeepCollectionEquality().hash(_revenueByTechnician));

@override
String toString() {
  return 'ReportData.technicianPerformance(technicianMetrics: $technicianMetrics, totalAppointments: $totalAppointments, averageRating: $averageRating, revenueByTechnician: $revenueByTechnician)';
}


}

/// @nodoc
abstract mixin class $TechnicianPerformanceReportDataCopyWith<$Res> implements $ReportDataCopyWith<$Res> {
  factory $TechnicianPerformanceReportDataCopyWith(TechnicianPerformanceReportData value, $Res Function(TechnicianPerformanceReportData) _then) = _$TechnicianPerformanceReportDataCopyWithImpl;
@useResult
$Res call({
 List<TechnicianMetrics> technicianMetrics, int totalAppointments, double averageRating, List<TechnicianRevenue> revenueByTechnician
});




}
/// @nodoc
class _$TechnicianPerformanceReportDataCopyWithImpl<$Res>
    implements $TechnicianPerformanceReportDataCopyWith<$Res> {
  _$TechnicianPerformanceReportDataCopyWithImpl(this._self, this._then);

  final TechnicianPerformanceReportData _self;
  final $Res Function(TechnicianPerformanceReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? technicianMetrics = null,Object? totalAppointments = null,Object? averageRating = null,Object? revenueByTechnician = null,}) {
  return _then(TechnicianPerformanceReportData(
technicianMetrics: null == technicianMetrics ? _self._technicianMetrics : technicianMetrics // ignore: cast_nullable_to_non_nullable
as List<TechnicianMetrics>,totalAppointments: null == totalAppointments ? _self.totalAppointments : totalAppointments // ignore: cast_nullable_to_non_nullable
as int,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,revenueByTechnician: null == revenueByTechnician ? _self._revenueByTechnician : revenueByTechnician // ignore: cast_nullable_to_non_nullable
as List<TechnicianRevenue>,
  ));
}


}

/// @nodoc


class CustomerAnalyticsReportData implements ReportData {
  const CustomerAnalyticsReportData({required this.totalCustomers, required this.newCustomersThisMonth, required this.returningCustomers, required this.averageVisitValue, required final  List<CustomerSegment> segments, required final  List<CustomerRetention> retentionData}): _segments = segments,_retentionData = retentionData;
  

 final  int totalCustomers;
 final  int newCustomersThisMonth;
 final  int returningCustomers;
 final  double averageVisitValue;
 final  List<CustomerSegment> _segments;
 List<CustomerSegment> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}

 final  List<CustomerRetention> _retentionData;
 List<CustomerRetention> get retentionData {
  if (_retentionData is EqualUnmodifiableListView) return _retentionData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_retentionData);
}


/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerAnalyticsReportDataCopyWith<CustomerAnalyticsReportData> get copyWith => _$CustomerAnalyticsReportDataCopyWithImpl<CustomerAnalyticsReportData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerAnalyticsReportData&&(identical(other.totalCustomers, totalCustomers) || other.totalCustomers == totalCustomers)&&(identical(other.newCustomersThisMonth, newCustomersThisMonth) || other.newCustomersThisMonth == newCustomersThisMonth)&&(identical(other.returningCustomers, returningCustomers) || other.returningCustomers == returningCustomers)&&(identical(other.averageVisitValue, averageVisitValue) || other.averageVisitValue == averageVisitValue)&&const DeepCollectionEquality().equals(other._segments, _segments)&&const DeepCollectionEquality().equals(other._retentionData, _retentionData));
}


@override
int get hashCode => Object.hash(runtimeType,totalCustomers,newCustomersThisMonth,returningCustomers,averageVisitValue,const DeepCollectionEquality().hash(_segments),const DeepCollectionEquality().hash(_retentionData));

@override
String toString() {
  return 'ReportData.customerAnalytics(totalCustomers: $totalCustomers, newCustomersThisMonth: $newCustomersThisMonth, returningCustomers: $returningCustomers, averageVisitValue: $averageVisitValue, segments: $segments, retentionData: $retentionData)';
}


}

/// @nodoc
abstract mixin class $CustomerAnalyticsReportDataCopyWith<$Res> implements $ReportDataCopyWith<$Res> {
  factory $CustomerAnalyticsReportDataCopyWith(CustomerAnalyticsReportData value, $Res Function(CustomerAnalyticsReportData) _then) = _$CustomerAnalyticsReportDataCopyWithImpl;
@useResult
$Res call({
 int totalCustomers, int newCustomersThisMonth, int returningCustomers, double averageVisitValue, List<CustomerSegment> segments, List<CustomerRetention> retentionData
});




}
/// @nodoc
class _$CustomerAnalyticsReportDataCopyWithImpl<$Res>
    implements $CustomerAnalyticsReportDataCopyWith<$Res> {
  _$CustomerAnalyticsReportDataCopyWithImpl(this._self, this._then);

  final CustomerAnalyticsReportData _self;
  final $Res Function(CustomerAnalyticsReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? totalCustomers = null,Object? newCustomersThisMonth = null,Object? returningCustomers = null,Object? averageVisitValue = null,Object? segments = null,Object? retentionData = null,}) {
  return _then(CustomerAnalyticsReportData(
totalCustomers: null == totalCustomers ? _self.totalCustomers : totalCustomers // ignore: cast_nullable_to_non_nullable
as int,newCustomersThisMonth: null == newCustomersThisMonth ? _self.newCustomersThisMonth : newCustomersThisMonth // ignore: cast_nullable_to_non_nullable
as int,returningCustomers: null == returningCustomers ? _self.returningCustomers : returningCustomers // ignore: cast_nullable_to_non_nullable
as int,averageVisitValue: null == averageVisitValue ? _self.averageVisitValue : averageVisitValue // ignore: cast_nullable_to_non_nullable
as double,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<CustomerSegment>,retentionData: null == retentionData ? _self._retentionData : retentionData // ignore: cast_nullable_to_non_nullable
as List<CustomerRetention>,
  ));
}


}

/// @nodoc


class AppointmentAnalyticsReportData implements ReportData {
  const AppointmentAnalyticsReportData({required this.totalAppointments, required this.completedAppointments, required this.cancelledAppointments, required this.showUpRate, required final  List<HourlyBooking> bookingPatterns, required final  List<AppointmentType> typeDistribution}): _bookingPatterns = bookingPatterns,_typeDistribution = typeDistribution;
  

 final  int totalAppointments;
 final  int completedAppointments;
 final  int cancelledAppointments;
 final  double showUpRate;
 final  List<HourlyBooking> _bookingPatterns;
 List<HourlyBooking> get bookingPatterns {
  if (_bookingPatterns is EqualUnmodifiableListView) return _bookingPatterns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookingPatterns);
}

 final  List<AppointmentType> _typeDistribution;
 List<AppointmentType> get typeDistribution {
  if (_typeDistribution is EqualUnmodifiableListView) return _typeDistribution;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_typeDistribution);
}


/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentAnalyticsReportDataCopyWith<AppointmentAnalyticsReportData> get copyWith => _$AppointmentAnalyticsReportDataCopyWithImpl<AppointmentAnalyticsReportData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentAnalyticsReportData&&(identical(other.totalAppointments, totalAppointments) || other.totalAppointments == totalAppointments)&&(identical(other.completedAppointments, completedAppointments) || other.completedAppointments == completedAppointments)&&(identical(other.cancelledAppointments, cancelledAppointments) || other.cancelledAppointments == cancelledAppointments)&&(identical(other.showUpRate, showUpRate) || other.showUpRate == showUpRate)&&const DeepCollectionEquality().equals(other._bookingPatterns, _bookingPatterns)&&const DeepCollectionEquality().equals(other._typeDistribution, _typeDistribution));
}


@override
int get hashCode => Object.hash(runtimeType,totalAppointments,completedAppointments,cancelledAppointments,showUpRate,const DeepCollectionEquality().hash(_bookingPatterns),const DeepCollectionEquality().hash(_typeDistribution));

@override
String toString() {
  return 'ReportData.appointmentAnalytics(totalAppointments: $totalAppointments, completedAppointments: $completedAppointments, cancelledAppointments: $cancelledAppointments, showUpRate: $showUpRate, bookingPatterns: $bookingPatterns, typeDistribution: $typeDistribution)';
}


}

/// @nodoc
abstract mixin class $AppointmentAnalyticsReportDataCopyWith<$Res> implements $ReportDataCopyWith<$Res> {
  factory $AppointmentAnalyticsReportDataCopyWith(AppointmentAnalyticsReportData value, $Res Function(AppointmentAnalyticsReportData) _then) = _$AppointmentAnalyticsReportDataCopyWithImpl;
@useResult
$Res call({
 int totalAppointments, int completedAppointments, int cancelledAppointments, double showUpRate, List<HourlyBooking> bookingPatterns, List<AppointmentType> typeDistribution
});




}
/// @nodoc
class _$AppointmentAnalyticsReportDataCopyWithImpl<$Res>
    implements $AppointmentAnalyticsReportDataCopyWith<$Res> {
  _$AppointmentAnalyticsReportDataCopyWithImpl(this._self, this._then);

  final AppointmentAnalyticsReportData _self;
  final $Res Function(AppointmentAnalyticsReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? totalAppointments = null,Object? completedAppointments = null,Object? cancelledAppointments = null,Object? showUpRate = null,Object? bookingPatterns = null,Object? typeDistribution = null,}) {
  return _then(AppointmentAnalyticsReportData(
totalAppointments: null == totalAppointments ? _self.totalAppointments : totalAppointments // ignore: cast_nullable_to_non_nullable
as int,completedAppointments: null == completedAppointments ? _self.completedAppointments : completedAppointments // ignore: cast_nullable_to_non_nullable
as int,cancelledAppointments: null == cancelledAppointments ? _self.cancelledAppointments : cancelledAppointments // ignore: cast_nullable_to_non_nullable
as int,showUpRate: null == showUpRate ? _self.showUpRate : showUpRate // ignore: cast_nullable_to_non_nullable
as double,bookingPatterns: null == bookingPatterns ? _self._bookingPatterns : bookingPatterns // ignore: cast_nullable_to_non_nullable
as List<HourlyBooking>,typeDistribution: null == typeDistribution ? _self._typeDistribution : typeDistribution // ignore: cast_nullable_to_non_nullable
as List<AppointmentType>,
  ));
}


}

/// @nodoc


class PaymentAnalyticsReportData implements ReportData {
  const PaymentAnalyticsReportData({required this.totalPayments, required final  Map<String, double> paymentMethodBreakdown, required this.averageTransactionAmount, required final  List<PaymentTrend> trends, required this.tipsTotal}): _paymentMethodBreakdown = paymentMethodBreakdown,_trends = trends;
  

 final  double totalPayments;
 final  Map<String, double> _paymentMethodBreakdown;
 Map<String, double> get paymentMethodBreakdown {
  if (_paymentMethodBreakdown is EqualUnmodifiableMapView) return _paymentMethodBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_paymentMethodBreakdown);
}

 final  double averageTransactionAmount;
 final  List<PaymentTrend> _trends;
 List<PaymentTrend> get trends {
  if (_trends is EqualUnmodifiableListView) return _trends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_trends);
}

 final  double tipsTotal;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentAnalyticsReportDataCopyWith<PaymentAnalyticsReportData> get copyWith => _$PaymentAnalyticsReportDataCopyWithImpl<PaymentAnalyticsReportData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentAnalyticsReportData&&(identical(other.totalPayments, totalPayments) || other.totalPayments == totalPayments)&&const DeepCollectionEquality().equals(other._paymentMethodBreakdown, _paymentMethodBreakdown)&&(identical(other.averageTransactionAmount, averageTransactionAmount) || other.averageTransactionAmount == averageTransactionAmount)&&const DeepCollectionEquality().equals(other._trends, _trends)&&(identical(other.tipsTotal, tipsTotal) || other.tipsTotal == tipsTotal));
}


@override
int get hashCode => Object.hash(runtimeType,totalPayments,const DeepCollectionEquality().hash(_paymentMethodBreakdown),averageTransactionAmount,const DeepCollectionEquality().hash(_trends),tipsTotal);

@override
String toString() {
  return 'ReportData.paymentAnalytics(totalPayments: $totalPayments, paymentMethodBreakdown: $paymentMethodBreakdown, averageTransactionAmount: $averageTransactionAmount, trends: $trends, tipsTotal: $tipsTotal)';
}


}

/// @nodoc
abstract mixin class $PaymentAnalyticsReportDataCopyWith<$Res> implements $ReportDataCopyWith<$Res> {
  factory $PaymentAnalyticsReportDataCopyWith(PaymentAnalyticsReportData value, $Res Function(PaymentAnalyticsReportData) _then) = _$PaymentAnalyticsReportDataCopyWithImpl;
@useResult
$Res call({
 double totalPayments, Map<String, double> paymentMethodBreakdown, double averageTransactionAmount, List<PaymentTrend> trends, double tipsTotal
});




}
/// @nodoc
class _$PaymentAnalyticsReportDataCopyWithImpl<$Res>
    implements $PaymentAnalyticsReportDataCopyWith<$Res> {
  _$PaymentAnalyticsReportDataCopyWithImpl(this._self, this._then);

  final PaymentAnalyticsReportData _self;
  final $Res Function(PaymentAnalyticsReportData) _then;

/// Create a copy of ReportData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? totalPayments = null,Object? paymentMethodBreakdown = null,Object? averageTransactionAmount = null,Object? trends = null,Object? tipsTotal = null,}) {
  return _then(PaymentAnalyticsReportData(
totalPayments: null == totalPayments ? _self.totalPayments : totalPayments // ignore: cast_nullable_to_non_nullable
as double,paymentMethodBreakdown: null == paymentMethodBreakdown ? _self._paymentMethodBreakdown : paymentMethodBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, double>,averageTransactionAmount: null == averageTransactionAmount ? _self.averageTransactionAmount : averageTransactionAmount // ignore: cast_nullable_to_non_nullable
as double,trends: null == trends ? _self._trends : trends // ignore: cast_nullable_to_non_nullable
as List<PaymentTrend>,tipsTotal: null == tipsTotal ? _self.tipsTotal : tipsTotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DailyRevenue {

 DateTime get date; double get revenue; int get serviceCount;
/// Create a copy of DailyRevenue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyRevenueCopyWith<DailyRevenue> get copyWith => _$DailyRevenueCopyWithImpl<DailyRevenue>(this as DailyRevenue, _$identity);

  /// Serializes this DailyRevenue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyRevenue&&(identical(other.date, date) || other.date == date)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.serviceCount, serviceCount) || other.serviceCount == serviceCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,revenue,serviceCount);

@override
String toString() {
  return 'DailyRevenue(date: $date, revenue: $revenue, serviceCount: $serviceCount)';
}


}

/// @nodoc
abstract mixin class $DailyRevenueCopyWith<$Res>  {
  factory $DailyRevenueCopyWith(DailyRevenue value, $Res Function(DailyRevenue) _then) = _$DailyRevenueCopyWithImpl;
@useResult
$Res call({
 DateTime date, double revenue, int serviceCount
});




}
/// @nodoc
class _$DailyRevenueCopyWithImpl<$Res>
    implements $DailyRevenueCopyWith<$Res> {
  _$DailyRevenueCopyWithImpl(this._self, this._then);

  final DailyRevenue _self;
  final $Res Function(DailyRevenue) _then;

/// Create a copy of DailyRevenue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? revenue = null,Object? serviceCount = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,serviceCount: null == serviceCount ? _self.serviceCount : serviceCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyRevenue].
extension DailyRevenuePatterns on DailyRevenue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyRevenue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyRevenue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyRevenue value)  $default,){
final _that = this;
switch (_that) {
case _DailyRevenue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyRevenue value)?  $default,){
final _that = this;
switch (_that) {
case _DailyRevenue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double revenue,  int serviceCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyRevenue() when $default != null:
return $default(_that.date,_that.revenue,_that.serviceCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double revenue,  int serviceCount)  $default,) {final _that = this;
switch (_that) {
case _DailyRevenue():
return $default(_that.date,_that.revenue,_that.serviceCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double revenue,  int serviceCount)?  $default,) {final _that = this;
switch (_that) {
case _DailyRevenue() when $default != null:
return $default(_that.date,_that.revenue,_that.serviceCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyRevenue implements DailyRevenue {
  const _DailyRevenue({required this.date, required this.revenue, required this.serviceCount});
  factory _DailyRevenue.fromJson(Map<String, dynamic> json) => _$DailyRevenueFromJson(json);

@override final  DateTime date;
@override final  double revenue;
@override final  int serviceCount;

/// Create a copy of DailyRevenue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyRevenueCopyWith<_DailyRevenue> get copyWith => __$DailyRevenueCopyWithImpl<_DailyRevenue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyRevenueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyRevenue&&(identical(other.date, date) || other.date == date)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.serviceCount, serviceCount) || other.serviceCount == serviceCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,revenue,serviceCount);

@override
String toString() {
  return 'DailyRevenue(date: $date, revenue: $revenue, serviceCount: $serviceCount)';
}


}

/// @nodoc
abstract mixin class _$DailyRevenueCopyWith<$Res> implements $DailyRevenueCopyWith<$Res> {
  factory _$DailyRevenueCopyWith(_DailyRevenue value, $Res Function(_DailyRevenue) _then) = __$DailyRevenueCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double revenue, int serviceCount
});




}
/// @nodoc
class __$DailyRevenueCopyWithImpl<$Res>
    implements _$DailyRevenueCopyWith<$Res> {
  __$DailyRevenueCopyWithImpl(this._self, this._then);

  final _DailyRevenue _self;
  final $Res Function(_DailyRevenue) _then;

/// Create a copy of DailyRevenue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? revenue = null,Object? serviceCount = null,}) {
  return _then(_DailyRevenue(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,serviceCount: null == serviceCount ? _self.serviceCount : serviceCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ServiceRevenue {

 String get serviceName; double get revenue; int get count; double get percentage;
/// Create a copy of ServiceRevenue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceRevenueCopyWith<ServiceRevenue> get copyWith => _$ServiceRevenueCopyWithImpl<ServiceRevenue>(this as ServiceRevenue, _$identity);

  /// Serializes this ServiceRevenue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceRevenue&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceName,revenue,count,percentage);

@override
String toString() {
  return 'ServiceRevenue(serviceName: $serviceName, revenue: $revenue, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $ServiceRevenueCopyWith<$Res>  {
  factory $ServiceRevenueCopyWith(ServiceRevenue value, $Res Function(ServiceRevenue) _then) = _$ServiceRevenueCopyWithImpl;
@useResult
$Res call({
 String serviceName, double revenue, int count, double percentage
});




}
/// @nodoc
class _$ServiceRevenueCopyWithImpl<$Res>
    implements $ServiceRevenueCopyWith<$Res> {
  _$ServiceRevenueCopyWithImpl(this._self, this._then);

  final ServiceRevenue _self;
  final $Res Function(ServiceRevenue) _then;

/// Create a copy of ServiceRevenue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceName = null,Object? revenue = null,Object? count = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceRevenue].
extension ServiceRevenuePatterns on ServiceRevenue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceRevenue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceRevenue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceRevenue value)  $default,){
final _that = this;
switch (_that) {
case _ServiceRevenue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceRevenue value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceRevenue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serviceName,  double revenue,  int count,  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceRevenue() when $default != null:
return $default(_that.serviceName,_that.revenue,_that.count,_that.percentage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serviceName,  double revenue,  int count,  double percentage)  $default,) {final _that = this;
switch (_that) {
case _ServiceRevenue():
return $default(_that.serviceName,_that.revenue,_that.count,_that.percentage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serviceName,  double revenue,  int count,  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _ServiceRevenue() when $default != null:
return $default(_that.serviceName,_that.revenue,_that.count,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceRevenue implements ServiceRevenue {
  const _ServiceRevenue({required this.serviceName, required this.revenue, required this.count, required this.percentage});
  factory _ServiceRevenue.fromJson(Map<String, dynamic> json) => _$ServiceRevenueFromJson(json);

@override final  String serviceName;
@override final  double revenue;
@override final  int count;
@override final  double percentage;

/// Create a copy of ServiceRevenue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceRevenueCopyWith<_ServiceRevenue> get copyWith => __$ServiceRevenueCopyWithImpl<_ServiceRevenue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceRevenueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceRevenue&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceName,revenue,count,percentage);

@override
String toString() {
  return 'ServiceRevenue(serviceName: $serviceName, revenue: $revenue, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$ServiceRevenueCopyWith<$Res> implements $ServiceRevenueCopyWith<$Res> {
  factory _$ServiceRevenueCopyWith(_ServiceRevenue value, $Res Function(_ServiceRevenue) _then) = __$ServiceRevenueCopyWithImpl;
@override @useResult
$Res call({
 String serviceName, double revenue, int count, double percentage
});




}
/// @nodoc
class __$ServiceRevenueCopyWithImpl<$Res>
    implements _$ServiceRevenueCopyWith<$Res> {
  __$ServiceRevenueCopyWithImpl(this._self, this._then);

  final _ServiceRevenue _self;
  final $Res Function(_ServiceRevenue) _then;

/// Create a copy of ServiceRevenue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceName = null,Object? revenue = null,Object? count = null,Object? percentage = null,}) {
  return _then(_ServiceRevenue(
serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ServiceMetrics {

 String get serviceName; int get timesBooked; double get revenue; double get averageRating; int get durationMinutes;
/// Create a copy of ServiceMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceMetricsCopyWith<ServiceMetrics> get copyWith => _$ServiceMetricsCopyWithImpl<ServiceMetrics>(this as ServiceMetrics, _$identity);

  /// Serializes this ServiceMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceMetrics&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.timesBooked, timesBooked) || other.timesBooked == timesBooked)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceName,timesBooked,revenue,averageRating,durationMinutes);

@override
String toString() {
  return 'ServiceMetrics(serviceName: $serviceName, timesBooked: $timesBooked, revenue: $revenue, averageRating: $averageRating, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class $ServiceMetricsCopyWith<$Res>  {
  factory $ServiceMetricsCopyWith(ServiceMetrics value, $Res Function(ServiceMetrics) _then) = _$ServiceMetricsCopyWithImpl;
@useResult
$Res call({
 String serviceName, int timesBooked, double revenue, double averageRating, int durationMinutes
});




}
/// @nodoc
class _$ServiceMetricsCopyWithImpl<$Res>
    implements $ServiceMetricsCopyWith<$Res> {
  _$ServiceMetricsCopyWithImpl(this._self, this._then);

  final ServiceMetrics _self;
  final $Res Function(ServiceMetrics) _then;

/// Create a copy of ServiceMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceName = null,Object? timesBooked = null,Object? revenue = null,Object? averageRating = null,Object? durationMinutes = null,}) {
  return _then(_self.copyWith(
serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,timesBooked: null == timesBooked ? _self.timesBooked : timesBooked // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceMetrics].
extension ServiceMetricsPatterns on ServiceMetrics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceMetrics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceMetrics value)  $default,){
final _that = this;
switch (_that) {
case _ServiceMetrics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceMetrics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serviceName,  int timesBooked,  double revenue,  double averageRating,  int durationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceMetrics() when $default != null:
return $default(_that.serviceName,_that.timesBooked,_that.revenue,_that.averageRating,_that.durationMinutes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serviceName,  int timesBooked,  double revenue,  double averageRating,  int durationMinutes)  $default,) {final _that = this;
switch (_that) {
case _ServiceMetrics():
return $default(_that.serviceName,_that.timesBooked,_that.revenue,_that.averageRating,_that.durationMinutes);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serviceName,  int timesBooked,  double revenue,  double averageRating,  int durationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _ServiceMetrics() when $default != null:
return $default(_that.serviceName,_that.timesBooked,_that.revenue,_that.averageRating,_that.durationMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceMetrics implements ServiceMetrics {
  const _ServiceMetrics({required this.serviceName, required this.timesBooked, required this.revenue, required this.averageRating, required this.durationMinutes});
  factory _ServiceMetrics.fromJson(Map<String, dynamic> json) => _$ServiceMetricsFromJson(json);

@override final  String serviceName;
@override final  int timesBooked;
@override final  double revenue;
@override final  double averageRating;
@override final  int durationMinutes;

/// Create a copy of ServiceMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceMetricsCopyWith<_ServiceMetrics> get copyWith => __$ServiceMetricsCopyWithImpl<_ServiceMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceMetrics&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&(identical(other.timesBooked, timesBooked) || other.timesBooked == timesBooked)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceName,timesBooked,revenue,averageRating,durationMinutes);

@override
String toString() {
  return 'ServiceMetrics(serviceName: $serviceName, timesBooked: $timesBooked, revenue: $revenue, averageRating: $averageRating, durationMinutes: $durationMinutes)';
}


}

/// @nodoc
abstract mixin class _$ServiceMetricsCopyWith<$Res> implements $ServiceMetricsCopyWith<$Res> {
  factory _$ServiceMetricsCopyWith(_ServiceMetrics value, $Res Function(_ServiceMetrics) _then) = __$ServiceMetricsCopyWithImpl;
@override @useResult
$Res call({
 String serviceName, int timesBooked, double revenue, double averageRating, int durationMinutes
});




}
/// @nodoc
class __$ServiceMetricsCopyWithImpl<$Res>
    implements _$ServiceMetricsCopyWith<$Res> {
  __$ServiceMetricsCopyWithImpl(this._self, this._then);

  final _ServiceMetrics _self;
  final $Res Function(_ServiceMetrics) _then;

/// Create a copy of ServiceMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceName = null,Object? timesBooked = null,Object? revenue = null,Object? averageRating = null,Object? durationMinutes = null,}) {
  return _then(_ServiceMetrics(
serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,timesBooked: null == timesBooked ? _self.timesBooked : timesBooked // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ServiceTrend {

 String get serviceName; List<TrendPoint> get dataPoints; double get growthRate;
/// Create a copy of ServiceTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceTrendCopyWith<ServiceTrend> get copyWith => _$ServiceTrendCopyWithImpl<ServiceTrend>(this as ServiceTrend, _$identity);

  /// Serializes this ServiceTrend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceTrend&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&const DeepCollectionEquality().equals(other.dataPoints, dataPoints)&&(identical(other.growthRate, growthRate) || other.growthRate == growthRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceName,const DeepCollectionEquality().hash(dataPoints),growthRate);

@override
String toString() {
  return 'ServiceTrend(serviceName: $serviceName, dataPoints: $dataPoints, growthRate: $growthRate)';
}


}

/// @nodoc
abstract mixin class $ServiceTrendCopyWith<$Res>  {
  factory $ServiceTrendCopyWith(ServiceTrend value, $Res Function(ServiceTrend) _then) = _$ServiceTrendCopyWithImpl;
@useResult
$Res call({
 String serviceName, List<TrendPoint> dataPoints, double growthRate
});




}
/// @nodoc
class _$ServiceTrendCopyWithImpl<$Res>
    implements $ServiceTrendCopyWith<$Res> {
  _$ServiceTrendCopyWithImpl(this._self, this._then);

  final ServiceTrend _self;
  final $Res Function(ServiceTrend) _then;

/// Create a copy of ServiceTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceName = null,Object? dataPoints = null,Object? growthRate = null,}) {
  return _then(_self.copyWith(
serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,dataPoints: null == dataPoints ? _self.dataPoints : dataPoints // ignore: cast_nullable_to_non_nullable
as List<TrendPoint>,growthRate: null == growthRate ? _self.growthRate : growthRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceTrend].
extension ServiceTrendPatterns on ServiceTrend {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceTrend() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceTrend value)  $default,){
final _that = this;
switch (_that) {
case _ServiceTrend():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceTrend value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceTrend() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serviceName,  List<TrendPoint> dataPoints,  double growthRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceTrend() when $default != null:
return $default(_that.serviceName,_that.dataPoints,_that.growthRate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serviceName,  List<TrendPoint> dataPoints,  double growthRate)  $default,) {final _that = this;
switch (_that) {
case _ServiceTrend():
return $default(_that.serviceName,_that.dataPoints,_that.growthRate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serviceName,  List<TrendPoint> dataPoints,  double growthRate)?  $default,) {final _that = this;
switch (_that) {
case _ServiceTrend() when $default != null:
return $default(_that.serviceName,_that.dataPoints,_that.growthRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceTrend implements ServiceTrend {
  const _ServiceTrend({required this.serviceName, required final  List<TrendPoint> dataPoints, required this.growthRate}): _dataPoints = dataPoints;
  factory _ServiceTrend.fromJson(Map<String, dynamic> json) => _$ServiceTrendFromJson(json);

@override final  String serviceName;
 final  List<TrendPoint> _dataPoints;
@override List<TrendPoint> get dataPoints {
  if (_dataPoints is EqualUnmodifiableListView) return _dataPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dataPoints);
}

@override final  double growthRate;

/// Create a copy of ServiceTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceTrendCopyWith<_ServiceTrend> get copyWith => __$ServiceTrendCopyWithImpl<_ServiceTrend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceTrendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceTrend&&(identical(other.serviceName, serviceName) || other.serviceName == serviceName)&&const DeepCollectionEquality().equals(other._dataPoints, _dataPoints)&&(identical(other.growthRate, growthRate) || other.growthRate == growthRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,serviceName,const DeepCollectionEquality().hash(_dataPoints),growthRate);

@override
String toString() {
  return 'ServiceTrend(serviceName: $serviceName, dataPoints: $dataPoints, growthRate: $growthRate)';
}


}

/// @nodoc
abstract mixin class _$ServiceTrendCopyWith<$Res> implements $ServiceTrendCopyWith<$Res> {
  factory _$ServiceTrendCopyWith(_ServiceTrend value, $Res Function(_ServiceTrend) _then) = __$ServiceTrendCopyWithImpl;
@override @useResult
$Res call({
 String serviceName, List<TrendPoint> dataPoints, double growthRate
});




}
/// @nodoc
class __$ServiceTrendCopyWithImpl<$Res>
    implements _$ServiceTrendCopyWith<$Res> {
  __$ServiceTrendCopyWithImpl(this._self, this._then);

  final _ServiceTrend _self;
  final $Res Function(_ServiceTrend) _then;

/// Create a copy of ServiceTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceName = null,Object? dataPoints = null,Object? growthRate = null,}) {
  return _then(_ServiceTrend(
serviceName: null == serviceName ? _self.serviceName : serviceName // ignore: cast_nullable_to_non_nullable
as String,dataPoints: null == dataPoints ? _self._dataPoints : dataPoints // ignore: cast_nullable_to_non_nullable
as List<TrendPoint>,growthRate: null == growthRate ? _self.growthRate : growthRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$TechnicianMetrics {

 String get technicianName; int get appointmentsCompleted; double get totalRevenue; double get averageRating; double get utilizationRate;
/// Create a copy of TechnicianMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianMetricsCopyWith<TechnicianMetrics> get copyWith => _$TechnicianMetricsCopyWithImpl<TechnicianMetrics>(this as TechnicianMetrics, _$identity);

  /// Serializes this TechnicianMetrics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianMetrics&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.appointmentsCompleted, appointmentsCompleted) || other.appointmentsCompleted == appointmentsCompleted)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.utilizationRate, utilizationRate) || other.utilizationRate == utilizationRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,technicianName,appointmentsCompleted,totalRevenue,averageRating,utilizationRate);

@override
String toString() {
  return 'TechnicianMetrics(technicianName: $technicianName, appointmentsCompleted: $appointmentsCompleted, totalRevenue: $totalRevenue, averageRating: $averageRating, utilizationRate: $utilizationRate)';
}


}

/// @nodoc
abstract mixin class $TechnicianMetricsCopyWith<$Res>  {
  factory $TechnicianMetricsCopyWith(TechnicianMetrics value, $Res Function(TechnicianMetrics) _then) = _$TechnicianMetricsCopyWithImpl;
@useResult
$Res call({
 String technicianName, int appointmentsCompleted, double totalRevenue, double averageRating, double utilizationRate
});




}
/// @nodoc
class _$TechnicianMetricsCopyWithImpl<$Res>
    implements $TechnicianMetricsCopyWith<$Res> {
  _$TechnicianMetricsCopyWithImpl(this._self, this._then);

  final TechnicianMetrics _self;
  final $Res Function(TechnicianMetrics) _then;

/// Create a copy of TechnicianMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? technicianName = null,Object? appointmentsCompleted = null,Object? totalRevenue = null,Object? averageRating = null,Object? utilizationRate = null,}) {
  return _then(_self.copyWith(
technicianName: null == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String,appointmentsCompleted: null == appointmentsCompleted ? _self.appointmentsCompleted : appointmentsCompleted // ignore: cast_nullable_to_non_nullable
as int,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,utilizationRate: null == utilizationRate ? _self.utilizationRate : utilizationRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianMetrics].
extension TechnicianMetricsPatterns on TechnicianMetrics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianMetrics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianMetrics value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianMetrics():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianMetrics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String technicianName,  int appointmentsCompleted,  double totalRevenue,  double averageRating,  double utilizationRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianMetrics() when $default != null:
return $default(_that.technicianName,_that.appointmentsCompleted,_that.totalRevenue,_that.averageRating,_that.utilizationRate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String technicianName,  int appointmentsCompleted,  double totalRevenue,  double averageRating,  double utilizationRate)  $default,) {final _that = this;
switch (_that) {
case _TechnicianMetrics():
return $default(_that.technicianName,_that.appointmentsCompleted,_that.totalRevenue,_that.averageRating,_that.utilizationRate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String technicianName,  int appointmentsCompleted,  double totalRevenue,  double averageRating,  double utilizationRate)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianMetrics() when $default != null:
return $default(_that.technicianName,_that.appointmentsCompleted,_that.totalRevenue,_that.averageRating,_that.utilizationRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechnicianMetrics implements TechnicianMetrics {
  const _TechnicianMetrics({required this.technicianName, required this.appointmentsCompleted, required this.totalRevenue, required this.averageRating, required this.utilizationRate});
  factory _TechnicianMetrics.fromJson(Map<String, dynamic> json) => _$TechnicianMetricsFromJson(json);

@override final  String technicianName;
@override final  int appointmentsCompleted;
@override final  double totalRevenue;
@override final  double averageRating;
@override final  double utilizationRate;

/// Create a copy of TechnicianMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianMetricsCopyWith<_TechnicianMetrics> get copyWith => __$TechnicianMetricsCopyWithImpl<_TechnicianMetrics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianMetricsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianMetrics&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.appointmentsCompleted, appointmentsCompleted) || other.appointmentsCompleted == appointmentsCompleted)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.averageRating, averageRating) || other.averageRating == averageRating)&&(identical(other.utilizationRate, utilizationRate) || other.utilizationRate == utilizationRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,technicianName,appointmentsCompleted,totalRevenue,averageRating,utilizationRate);

@override
String toString() {
  return 'TechnicianMetrics(technicianName: $technicianName, appointmentsCompleted: $appointmentsCompleted, totalRevenue: $totalRevenue, averageRating: $averageRating, utilizationRate: $utilizationRate)';
}


}

/// @nodoc
abstract mixin class _$TechnicianMetricsCopyWith<$Res> implements $TechnicianMetricsCopyWith<$Res> {
  factory _$TechnicianMetricsCopyWith(_TechnicianMetrics value, $Res Function(_TechnicianMetrics) _then) = __$TechnicianMetricsCopyWithImpl;
@override @useResult
$Res call({
 String technicianName, int appointmentsCompleted, double totalRevenue, double averageRating, double utilizationRate
});




}
/// @nodoc
class __$TechnicianMetricsCopyWithImpl<$Res>
    implements _$TechnicianMetricsCopyWith<$Res> {
  __$TechnicianMetricsCopyWithImpl(this._self, this._then);

  final _TechnicianMetrics _self;
  final $Res Function(_TechnicianMetrics) _then;

/// Create a copy of TechnicianMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? technicianName = null,Object? appointmentsCompleted = null,Object? totalRevenue = null,Object? averageRating = null,Object? utilizationRate = null,}) {
  return _then(_TechnicianMetrics(
technicianName: null == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String,appointmentsCompleted: null == appointmentsCompleted ? _self.appointmentsCompleted : appointmentsCompleted // ignore: cast_nullable_to_non_nullable
as int,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as double,averageRating: null == averageRating ? _self.averageRating : averageRating // ignore: cast_nullable_to_non_nullable
as double,utilizationRate: null == utilizationRate ? _self.utilizationRate : utilizationRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$TechnicianRevenue {

 String get technicianName; double get revenue; List<DailyRevenue> get dailyBreakdown;
/// Create a copy of TechnicianRevenue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechnicianRevenueCopyWith<TechnicianRevenue> get copyWith => _$TechnicianRevenueCopyWithImpl<TechnicianRevenue>(this as TechnicianRevenue, _$identity);

  /// Serializes this TechnicianRevenue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechnicianRevenue&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&const DeepCollectionEquality().equals(other.dailyBreakdown, dailyBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,technicianName,revenue,const DeepCollectionEquality().hash(dailyBreakdown));

@override
String toString() {
  return 'TechnicianRevenue(technicianName: $technicianName, revenue: $revenue, dailyBreakdown: $dailyBreakdown)';
}


}

/// @nodoc
abstract mixin class $TechnicianRevenueCopyWith<$Res>  {
  factory $TechnicianRevenueCopyWith(TechnicianRevenue value, $Res Function(TechnicianRevenue) _then) = _$TechnicianRevenueCopyWithImpl;
@useResult
$Res call({
 String technicianName, double revenue, List<DailyRevenue> dailyBreakdown
});




}
/// @nodoc
class _$TechnicianRevenueCopyWithImpl<$Res>
    implements $TechnicianRevenueCopyWith<$Res> {
  _$TechnicianRevenueCopyWithImpl(this._self, this._then);

  final TechnicianRevenue _self;
  final $Res Function(TechnicianRevenue) _then;

/// Create a copy of TechnicianRevenue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? technicianName = null,Object? revenue = null,Object? dailyBreakdown = null,}) {
  return _then(_self.copyWith(
technicianName: null == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,dailyBreakdown: null == dailyBreakdown ? _self.dailyBreakdown : dailyBreakdown // ignore: cast_nullable_to_non_nullable
as List<DailyRevenue>,
  ));
}

}


/// Adds pattern-matching-related methods to [TechnicianRevenue].
extension TechnicianRevenuePatterns on TechnicianRevenue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechnicianRevenue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechnicianRevenue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechnicianRevenue value)  $default,){
final _that = this;
switch (_that) {
case _TechnicianRevenue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechnicianRevenue value)?  $default,){
final _that = this;
switch (_that) {
case _TechnicianRevenue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String technicianName,  double revenue,  List<DailyRevenue> dailyBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechnicianRevenue() when $default != null:
return $default(_that.technicianName,_that.revenue,_that.dailyBreakdown);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String technicianName,  double revenue,  List<DailyRevenue> dailyBreakdown)  $default,) {final _that = this;
switch (_that) {
case _TechnicianRevenue():
return $default(_that.technicianName,_that.revenue,_that.dailyBreakdown);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String technicianName,  double revenue,  List<DailyRevenue> dailyBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _TechnicianRevenue() when $default != null:
return $default(_that.technicianName,_that.revenue,_that.dailyBreakdown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechnicianRevenue implements TechnicianRevenue {
  const _TechnicianRevenue({required this.technicianName, required this.revenue, required final  List<DailyRevenue> dailyBreakdown}): _dailyBreakdown = dailyBreakdown;
  factory _TechnicianRevenue.fromJson(Map<String, dynamic> json) => _$TechnicianRevenueFromJson(json);

@override final  String technicianName;
@override final  double revenue;
 final  List<DailyRevenue> _dailyBreakdown;
@override List<DailyRevenue> get dailyBreakdown {
  if (_dailyBreakdown is EqualUnmodifiableListView) return _dailyBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyBreakdown);
}


/// Create a copy of TechnicianRevenue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechnicianRevenueCopyWith<_TechnicianRevenue> get copyWith => __$TechnicianRevenueCopyWithImpl<_TechnicianRevenue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechnicianRevenueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechnicianRevenue&&(identical(other.technicianName, technicianName) || other.technicianName == technicianName)&&(identical(other.revenue, revenue) || other.revenue == revenue)&&const DeepCollectionEquality().equals(other._dailyBreakdown, _dailyBreakdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,technicianName,revenue,const DeepCollectionEquality().hash(_dailyBreakdown));

@override
String toString() {
  return 'TechnicianRevenue(technicianName: $technicianName, revenue: $revenue, dailyBreakdown: $dailyBreakdown)';
}


}

/// @nodoc
abstract mixin class _$TechnicianRevenueCopyWith<$Res> implements $TechnicianRevenueCopyWith<$Res> {
  factory _$TechnicianRevenueCopyWith(_TechnicianRevenue value, $Res Function(_TechnicianRevenue) _then) = __$TechnicianRevenueCopyWithImpl;
@override @useResult
$Res call({
 String technicianName, double revenue, List<DailyRevenue> dailyBreakdown
});




}
/// @nodoc
class __$TechnicianRevenueCopyWithImpl<$Res>
    implements _$TechnicianRevenueCopyWith<$Res> {
  __$TechnicianRevenueCopyWithImpl(this._self, this._then);

  final _TechnicianRevenue _self;
  final $Res Function(_TechnicianRevenue) _then;

/// Create a copy of TechnicianRevenue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? technicianName = null,Object? revenue = null,Object? dailyBreakdown = null,}) {
  return _then(_TechnicianRevenue(
technicianName: null == technicianName ? _self.technicianName : technicianName // ignore: cast_nullable_to_non_nullable
as String,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as double,dailyBreakdown: null == dailyBreakdown ? _self._dailyBreakdown : dailyBreakdown // ignore: cast_nullable_to_non_nullable
as List<DailyRevenue>,
  ));
}


}


/// @nodoc
mixin _$CustomerSegment {

 String get segment; int get count; double get percentage; double get averageSpend;
/// Create a copy of CustomerSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerSegmentCopyWith<CustomerSegment> get copyWith => _$CustomerSegmentCopyWithImpl<CustomerSegment>(this as CustomerSegment, _$identity);

  /// Serializes this CustomerSegment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerSegment&&(identical(other.segment, segment) || other.segment == segment)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.averageSpend, averageSpend) || other.averageSpend == averageSpend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,segment,count,percentage,averageSpend);

@override
String toString() {
  return 'CustomerSegment(segment: $segment, count: $count, percentage: $percentage, averageSpend: $averageSpend)';
}


}

/// @nodoc
abstract mixin class $CustomerSegmentCopyWith<$Res>  {
  factory $CustomerSegmentCopyWith(CustomerSegment value, $Res Function(CustomerSegment) _then) = _$CustomerSegmentCopyWithImpl;
@useResult
$Res call({
 String segment, int count, double percentage, double averageSpend
});




}
/// @nodoc
class _$CustomerSegmentCopyWithImpl<$Res>
    implements $CustomerSegmentCopyWith<$Res> {
  _$CustomerSegmentCopyWithImpl(this._self, this._then);

  final CustomerSegment _self;
  final $Res Function(CustomerSegment) _then;

/// Create a copy of CustomerSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? segment = null,Object? count = null,Object? percentage = null,Object? averageSpend = null,}) {
  return _then(_self.copyWith(
segment: null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,averageSpend: null == averageSpend ? _self.averageSpend : averageSpend // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerSegment].
extension CustomerSegmentPatterns on CustomerSegment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerSegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerSegment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerSegment value)  $default,){
final _that = this;
switch (_that) {
case _CustomerSegment():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerSegment value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerSegment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String segment,  int count,  double percentage,  double averageSpend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerSegment() when $default != null:
return $default(_that.segment,_that.count,_that.percentage,_that.averageSpend);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String segment,  int count,  double percentage,  double averageSpend)  $default,) {final _that = this;
switch (_that) {
case _CustomerSegment():
return $default(_that.segment,_that.count,_that.percentage,_that.averageSpend);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String segment,  int count,  double percentage,  double averageSpend)?  $default,) {final _that = this;
switch (_that) {
case _CustomerSegment() when $default != null:
return $default(_that.segment,_that.count,_that.percentage,_that.averageSpend);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerSegment implements CustomerSegment {
  const _CustomerSegment({required this.segment, required this.count, required this.percentage, required this.averageSpend});
  factory _CustomerSegment.fromJson(Map<String, dynamic> json) => _$CustomerSegmentFromJson(json);

@override final  String segment;
@override final  int count;
@override final  double percentage;
@override final  double averageSpend;

/// Create a copy of CustomerSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerSegmentCopyWith<_CustomerSegment> get copyWith => __$CustomerSegmentCopyWithImpl<_CustomerSegment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerSegmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerSegment&&(identical(other.segment, segment) || other.segment == segment)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.averageSpend, averageSpend) || other.averageSpend == averageSpend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,segment,count,percentage,averageSpend);

@override
String toString() {
  return 'CustomerSegment(segment: $segment, count: $count, percentage: $percentage, averageSpend: $averageSpend)';
}


}

/// @nodoc
abstract mixin class _$CustomerSegmentCopyWith<$Res> implements $CustomerSegmentCopyWith<$Res> {
  factory _$CustomerSegmentCopyWith(_CustomerSegment value, $Res Function(_CustomerSegment) _then) = __$CustomerSegmentCopyWithImpl;
@override @useResult
$Res call({
 String segment, int count, double percentage, double averageSpend
});




}
/// @nodoc
class __$CustomerSegmentCopyWithImpl<$Res>
    implements _$CustomerSegmentCopyWith<$Res> {
  __$CustomerSegmentCopyWithImpl(this._self, this._then);

  final _CustomerSegment _self;
  final $Res Function(_CustomerSegment) _then;

/// Create a copy of CustomerSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? segment = null,Object? count = null,Object? percentage = null,Object? averageSpend = null,}) {
  return _then(_CustomerSegment(
segment: null == segment ? _self.segment : segment // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,averageSpend: null == averageSpend ? _self.averageSpend : averageSpend // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$CustomerRetention {

 DateTime get month; double get retentionRate; int get newCustomers; int get returningCustomers;
/// Create a copy of CustomerRetention
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomerRetentionCopyWith<CustomerRetention> get copyWith => _$CustomerRetentionCopyWithImpl<CustomerRetention>(this as CustomerRetention, _$identity);

  /// Serializes this CustomerRetention to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomerRetention&&(identical(other.month, month) || other.month == month)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.newCustomers, newCustomers) || other.newCustomers == newCustomers)&&(identical(other.returningCustomers, returningCustomers) || other.returningCustomers == returningCustomers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,retentionRate,newCustomers,returningCustomers);

@override
String toString() {
  return 'CustomerRetention(month: $month, retentionRate: $retentionRate, newCustomers: $newCustomers, returningCustomers: $returningCustomers)';
}


}

/// @nodoc
abstract mixin class $CustomerRetentionCopyWith<$Res>  {
  factory $CustomerRetentionCopyWith(CustomerRetention value, $Res Function(CustomerRetention) _then) = _$CustomerRetentionCopyWithImpl;
@useResult
$Res call({
 DateTime month, double retentionRate, int newCustomers, int returningCustomers
});




}
/// @nodoc
class _$CustomerRetentionCopyWithImpl<$Res>
    implements $CustomerRetentionCopyWith<$Res> {
  _$CustomerRetentionCopyWithImpl(this._self, this._then);

  final CustomerRetention _self;
  final $Res Function(CustomerRetention) _then;

/// Create a copy of CustomerRetention
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? retentionRate = null,Object? newCustomers = null,Object? returningCustomers = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double,newCustomers: null == newCustomers ? _self.newCustomers : newCustomers // ignore: cast_nullable_to_non_nullable
as int,returningCustomers: null == returningCustomers ? _self.returningCustomers : returningCustomers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomerRetention].
extension CustomerRetentionPatterns on CustomerRetention {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomerRetention value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomerRetention() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomerRetention value)  $default,){
final _that = this;
switch (_that) {
case _CustomerRetention():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomerRetention value)?  $default,){
final _that = this;
switch (_that) {
case _CustomerRetention() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime month,  double retentionRate,  int newCustomers,  int returningCustomers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomerRetention() when $default != null:
return $default(_that.month,_that.retentionRate,_that.newCustomers,_that.returningCustomers);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime month,  double retentionRate,  int newCustomers,  int returningCustomers)  $default,) {final _that = this;
switch (_that) {
case _CustomerRetention():
return $default(_that.month,_that.retentionRate,_that.newCustomers,_that.returningCustomers);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime month,  double retentionRate,  int newCustomers,  int returningCustomers)?  $default,) {final _that = this;
switch (_that) {
case _CustomerRetention() when $default != null:
return $default(_that.month,_that.retentionRate,_that.newCustomers,_that.returningCustomers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomerRetention implements CustomerRetention {
  const _CustomerRetention({required this.month, required this.retentionRate, required this.newCustomers, required this.returningCustomers});
  factory _CustomerRetention.fromJson(Map<String, dynamic> json) => _$CustomerRetentionFromJson(json);

@override final  DateTime month;
@override final  double retentionRate;
@override final  int newCustomers;
@override final  int returningCustomers;

/// Create a copy of CustomerRetention
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomerRetentionCopyWith<_CustomerRetention> get copyWith => __$CustomerRetentionCopyWithImpl<_CustomerRetention>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomerRetentionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomerRetention&&(identical(other.month, month) || other.month == month)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.newCustomers, newCustomers) || other.newCustomers == newCustomers)&&(identical(other.returningCustomers, returningCustomers) || other.returningCustomers == returningCustomers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,retentionRate,newCustomers,returningCustomers);

@override
String toString() {
  return 'CustomerRetention(month: $month, retentionRate: $retentionRate, newCustomers: $newCustomers, returningCustomers: $returningCustomers)';
}


}

/// @nodoc
abstract mixin class _$CustomerRetentionCopyWith<$Res> implements $CustomerRetentionCopyWith<$Res> {
  factory _$CustomerRetentionCopyWith(_CustomerRetention value, $Res Function(_CustomerRetention) _then) = __$CustomerRetentionCopyWithImpl;
@override @useResult
$Res call({
 DateTime month, double retentionRate, int newCustomers, int returningCustomers
});




}
/// @nodoc
class __$CustomerRetentionCopyWithImpl<$Res>
    implements _$CustomerRetentionCopyWith<$Res> {
  __$CustomerRetentionCopyWithImpl(this._self, this._then);

  final _CustomerRetention _self;
  final $Res Function(_CustomerRetention) _then;

/// Create a copy of CustomerRetention
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? retentionRate = null,Object? newCustomers = null,Object? returningCustomers = null,}) {
  return _then(_CustomerRetention(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as DateTime,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double,newCustomers: null == newCustomers ? _self.newCustomers : newCustomers // ignore: cast_nullable_to_non_nullable
as int,returningCustomers: null == returningCustomers ? _self.returningCustomers : returningCustomers // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$HourlyBooking {

 int get hour; int get bookingCount; double get percentage;
/// Create a copy of HourlyBooking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HourlyBookingCopyWith<HourlyBooking> get copyWith => _$HourlyBookingCopyWithImpl<HourlyBooking>(this as HourlyBooking, _$identity);

  /// Serializes this HourlyBooking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HourlyBooking&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.bookingCount, bookingCount) || other.bookingCount == bookingCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,bookingCount,percentage);

@override
String toString() {
  return 'HourlyBooking(hour: $hour, bookingCount: $bookingCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $HourlyBookingCopyWith<$Res>  {
  factory $HourlyBookingCopyWith(HourlyBooking value, $Res Function(HourlyBooking) _then) = _$HourlyBookingCopyWithImpl;
@useResult
$Res call({
 int hour, int bookingCount, double percentage
});




}
/// @nodoc
class _$HourlyBookingCopyWithImpl<$Res>
    implements $HourlyBookingCopyWith<$Res> {
  _$HourlyBookingCopyWithImpl(this._self, this._then);

  final HourlyBooking _self;
  final $Res Function(HourlyBooking) _then;

/// Create a copy of HourlyBooking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? bookingCount = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,bookingCount: null == bookingCount ? _self.bookingCount : bookingCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [HourlyBooking].
extension HourlyBookingPatterns on HourlyBooking {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HourlyBooking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HourlyBooking() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HourlyBooking value)  $default,){
final _that = this;
switch (_that) {
case _HourlyBooking():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HourlyBooking value)?  $default,){
final _that = this;
switch (_that) {
case _HourlyBooking() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int bookingCount,  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HourlyBooking() when $default != null:
return $default(_that.hour,_that.bookingCount,_that.percentage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int bookingCount,  double percentage)  $default,) {final _that = this;
switch (_that) {
case _HourlyBooking():
return $default(_that.hour,_that.bookingCount,_that.percentage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int bookingCount,  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _HourlyBooking() when $default != null:
return $default(_that.hour,_that.bookingCount,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HourlyBooking implements HourlyBooking {
  const _HourlyBooking({required this.hour, required this.bookingCount, required this.percentage});
  factory _HourlyBooking.fromJson(Map<String, dynamic> json) => _$HourlyBookingFromJson(json);

@override final  int hour;
@override final  int bookingCount;
@override final  double percentage;

/// Create a copy of HourlyBooking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HourlyBookingCopyWith<_HourlyBooking> get copyWith => __$HourlyBookingCopyWithImpl<_HourlyBooking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HourlyBookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HourlyBooking&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.bookingCount, bookingCount) || other.bookingCount == bookingCount)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,bookingCount,percentage);

@override
String toString() {
  return 'HourlyBooking(hour: $hour, bookingCount: $bookingCount, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$HourlyBookingCopyWith<$Res> implements $HourlyBookingCopyWith<$Res> {
  factory _$HourlyBookingCopyWith(_HourlyBooking value, $Res Function(_HourlyBooking) _then) = __$HourlyBookingCopyWithImpl;
@override @useResult
$Res call({
 int hour, int bookingCount, double percentage
});




}
/// @nodoc
class __$HourlyBookingCopyWithImpl<$Res>
    implements _$HourlyBookingCopyWith<$Res> {
  __$HourlyBookingCopyWithImpl(this._self, this._then);

  final _HourlyBooking _self;
  final $Res Function(_HourlyBooking) _then;

/// Create a copy of HourlyBooking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? bookingCount = null,Object? percentage = null,}) {
  return _then(_HourlyBooking(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,bookingCount: null == bookingCount ? _self.bookingCount : bookingCount // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AppointmentType {

 String get type; int get count; double get percentage;
/// Create a copy of AppointmentType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentTypeCopyWith<AppointmentType> get copyWith => _$AppointmentTypeCopyWithImpl<AppointmentType>(this as AppointmentType, _$identity);

  /// Serializes this AppointmentType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentType&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,count,percentage);

@override
String toString() {
  return 'AppointmentType(type: $type, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class $AppointmentTypeCopyWith<$Res>  {
  factory $AppointmentTypeCopyWith(AppointmentType value, $Res Function(AppointmentType) _then) = _$AppointmentTypeCopyWithImpl;
@useResult
$Res call({
 String type, int count, double percentage
});




}
/// @nodoc
class _$AppointmentTypeCopyWithImpl<$Res>
    implements $AppointmentTypeCopyWith<$Res> {
  _$AppointmentTypeCopyWithImpl(this._self, this._then);

  final AppointmentType _self;
  final $Res Function(AppointmentType) _then;

/// Create a copy of AppointmentType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? count = null,Object? percentage = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentType].
extension AppointmentTypePatterns on AppointmentType {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentType() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentType value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentType():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentType value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentType() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  int count,  double percentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentType() when $default != null:
return $default(_that.type,_that.count,_that.percentage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  int count,  double percentage)  $default,) {final _that = this;
switch (_that) {
case _AppointmentType():
return $default(_that.type,_that.count,_that.percentage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  int count,  double percentage)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentType() when $default != null:
return $default(_that.type,_that.count,_that.percentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentType implements AppointmentType {
  const _AppointmentType({required this.type, required this.count, required this.percentage});
  factory _AppointmentType.fromJson(Map<String, dynamic> json) => _$AppointmentTypeFromJson(json);

@override final  String type;
@override final  int count;
@override final  double percentage;

/// Create a copy of AppointmentType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentTypeCopyWith<_AppointmentType> get copyWith => __$AppointmentTypeCopyWithImpl<_AppointmentType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentType&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count)&&(identical(other.percentage, percentage) || other.percentage == percentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,count,percentage);

@override
String toString() {
  return 'AppointmentType(type: $type, count: $count, percentage: $percentage)';
}


}

/// @nodoc
abstract mixin class _$AppointmentTypeCopyWith<$Res> implements $AppointmentTypeCopyWith<$Res> {
  factory _$AppointmentTypeCopyWith(_AppointmentType value, $Res Function(_AppointmentType) _then) = __$AppointmentTypeCopyWithImpl;
@override @useResult
$Res call({
 String type, int count, double percentage
});




}
/// @nodoc
class __$AppointmentTypeCopyWithImpl<$Res>
    implements _$AppointmentTypeCopyWith<$Res> {
  __$AppointmentTypeCopyWithImpl(this._self, this._then);

  final _AppointmentType _self;
  final $Res Function(_AppointmentType) _then;

/// Create a copy of AppointmentType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? count = null,Object? percentage = null,}) {
  return _then(_AppointmentType(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$PaymentTrend {

 DateTime get date; double get amount; String get paymentMethod;
/// Create a copy of PaymentTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentTrendCopyWith<PaymentTrend> get copyWith => _$PaymentTrendCopyWithImpl<PaymentTrend>(this as PaymentTrend, _$identity);

  /// Serializes this PaymentTrend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentTrend&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,amount,paymentMethod);

@override
String toString() {
  return 'PaymentTrend(date: $date, amount: $amount, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class $PaymentTrendCopyWith<$Res>  {
  factory $PaymentTrendCopyWith(PaymentTrend value, $Res Function(PaymentTrend) _then) = _$PaymentTrendCopyWithImpl;
@useResult
$Res call({
 DateTime date, double amount, String paymentMethod
});




}
/// @nodoc
class _$PaymentTrendCopyWithImpl<$Res>
    implements $PaymentTrendCopyWith<$Res> {
  _$PaymentTrendCopyWithImpl(this._self, this._then);

  final PaymentTrend _self;
  final $Res Function(PaymentTrend) _then;

/// Create a copy of PaymentTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? amount = null,Object? paymentMethod = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentTrend].
extension PaymentTrendPatterns on PaymentTrend {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentTrend() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentTrend value)  $default,){
final _that = this;
switch (_that) {
case _PaymentTrend():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentTrend value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentTrend() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double amount,  String paymentMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentTrend() when $default != null:
return $default(_that.date,_that.amount,_that.paymentMethod);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double amount,  String paymentMethod)  $default,) {final _that = this;
switch (_that) {
case _PaymentTrend():
return $default(_that.date,_that.amount,_that.paymentMethod);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double amount,  String paymentMethod)?  $default,) {final _that = this;
switch (_that) {
case _PaymentTrend() when $default != null:
return $default(_that.date,_that.amount,_that.paymentMethod);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentTrend implements PaymentTrend {
  const _PaymentTrend({required this.date, required this.amount, required this.paymentMethod});
  factory _PaymentTrend.fromJson(Map<String, dynamic> json) => _$PaymentTrendFromJson(json);

@override final  DateTime date;
@override final  double amount;
@override final  String paymentMethod;

/// Create a copy of PaymentTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentTrendCopyWith<_PaymentTrend> get copyWith => __$PaymentTrendCopyWithImpl<_PaymentTrend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentTrendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentTrend&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,amount,paymentMethod);

@override
String toString() {
  return 'PaymentTrend(date: $date, amount: $amount, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class _$PaymentTrendCopyWith<$Res> implements $PaymentTrendCopyWith<$Res> {
  factory _$PaymentTrendCopyWith(_PaymentTrend value, $Res Function(_PaymentTrend) _then) = __$PaymentTrendCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double amount, String paymentMethod
});




}
/// @nodoc
class __$PaymentTrendCopyWithImpl<$Res>
    implements _$PaymentTrendCopyWith<$Res> {
  __$PaymentTrendCopyWithImpl(this._self, this._then);

  final _PaymentTrend _self;
  final $Res Function(_PaymentTrend) _then;

/// Create a copy of PaymentTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? amount = null,Object? paymentMethod = null,}) {
  return _then(_PaymentTrend(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$TrendPoint {

 DateTime get date; double get value;
/// Create a copy of TrendPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendPointCopyWith<TrendPoint> get copyWith => _$TrendPointCopyWithImpl<TrendPoint>(this as TrendPoint, _$identity);

  /// Serializes this TrendPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,value);

@override
String toString() {
  return 'TrendPoint(date: $date, value: $value)';
}


}

/// @nodoc
abstract mixin class $TrendPointCopyWith<$Res>  {
  factory $TrendPointCopyWith(TrendPoint value, $Res Function(TrendPoint) _then) = _$TrendPointCopyWithImpl;
@useResult
$Res call({
 DateTime date, double value
});




}
/// @nodoc
class _$TrendPointCopyWithImpl<$Res>
    implements $TrendPointCopyWith<$Res> {
  _$TrendPointCopyWithImpl(this._self, this._then);

  final TrendPoint _self;
  final $Res Function(TrendPoint) _then;

/// Create a copy of TrendPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? value = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TrendPoint].
extension TrendPointPatterns on TrendPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendPoint value)  $default,){
final _that = this;
switch (_that) {
case _TrendPoint():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendPoint value)?  $default,){
final _that = this;
switch (_that) {
case _TrendPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendPoint() when $default != null:
return $default(_that.date,_that.value);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double value)  $default,) {final _that = this;
switch (_that) {
case _TrendPoint():
return $default(_that.date,_that.value);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double value)?  $default,) {final _that = this;
switch (_that) {
case _TrendPoint() when $default != null:
return $default(_that.date,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrendPoint implements TrendPoint {
  const _TrendPoint({required this.date, required this.value});
  factory _TrendPoint.fromJson(Map<String, dynamic> json) => _$TrendPointFromJson(json);

@override final  DateTime date;
@override final  double value;

/// Create a copy of TrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendPointCopyWith<_TrendPoint> get copyWith => __$TrendPointCopyWithImpl<_TrendPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrendPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendPoint&&(identical(other.date, date) || other.date == date)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,value);

@override
String toString() {
  return 'TrendPoint(date: $date, value: $value)';
}


}

/// @nodoc
abstract mixin class _$TrendPointCopyWith<$Res> implements $TrendPointCopyWith<$Res> {
  factory _$TrendPointCopyWith(_TrendPoint value, $Res Function(_TrendPoint) _then) = __$TrendPointCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double value
});




}
/// @nodoc
class __$TrendPointCopyWithImpl<$Res>
    implements _$TrendPointCopyWith<$Res> {
  __$TrendPointCopyWithImpl(this._self, this._then);

  final _TrendPoint _self;
  final $Res Function(_TrendPoint) _then;

/// Create a copy of TrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? value = null,}) {
  return _then(_TrendPoint(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

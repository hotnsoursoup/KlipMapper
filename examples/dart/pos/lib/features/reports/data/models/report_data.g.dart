// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DailyRevenue _$DailyRevenueFromJson(Map<String, dynamic> json) =>
    _DailyRevenue(
      date: DateTime.parse(json['date'] as String),
      revenue: (json['revenue'] as num).toDouble(),
      serviceCount: (json['serviceCount'] as num).toInt(),
    );

Map<String, dynamic> _$DailyRevenueToJson(_DailyRevenue instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'revenue': instance.revenue,
      'serviceCount': instance.serviceCount,
    };

_ServiceRevenue _$ServiceRevenueFromJson(Map<String, dynamic> json) =>
    _ServiceRevenue(
      serviceName: json['serviceName'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$ServiceRevenueToJson(_ServiceRevenue instance) =>
    <String, dynamic>{
      'serviceName': instance.serviceName,
      'revenue': instance.revenue,
      'count': instance.count,
      'percentage': instance.percentage,
    };

_ServiceMetrics _$ServiceMetricsFromJson(Map<String, dynamic> json) =>
    _ServiceMetrics(
      serviceName: json['serviceName'] as String,
      timesBooked: (json['timesBooked'] as num).toInt(),
      revenue: (json['revenue'] as num).toDouble(),
      averageRating: (json['averageRating'] as num).toDouble(),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$ServiceMetricsToJson(_ServiceMetrics instance) =>
    <String, dynamic>{
      'serviceName': instance.serviceName,
      'timesBooked': instance.timesBooked,
      'revenue': instance.revenue,
      'averageRating': instance.averageRating,
      'durationMinutes': instance.durationMinutes,
    };

_ServiceTrend _$ServiceTrendFromJson(Map<String, dynamic> json) =>
    _ServiceTrend(
      serviceName: json['serviceName'] as String,
      dataPoints: (json['dataPoints'] as List<dynamic>)
          .map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      growthRate: (json['growthRate'] as num).toDouble(),
    );

Map<String, dynamic> _$ServiceTrendToJson(_ServiceTrend instance) =>
    <String, dynamic>{
      'serviceName': instance.serviceName,
      'dataPoints': instance.dataPoints,
      'growthRate': instance.growthRate,
    };

_TechnicianMetrics _$TechnicianMetricsFromJson(Map<String, dynamic> json) =>
    _TechnicianMetrics(
      technicianName: json['technicianName'] as String,
      appointmentsCompleted: (json['appointmentsCompleted'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      averageRating: (json['averageRating'] as num).toDouble(),
      utilizationRate: (json['utilizationRate'] as num).toDouble(),
    );

Map<String, dynamic> _$TechnicianMetricsToJson(_TechnicianMetrics instance) =>
    <String, dynamic>{
      'technicianName': instance.technicianName,
      'appointmentsCompleted': instance.appointmentsCompleted,
      'totalRevenue': instance.totalRevenue,
      'averageRating': instance.averageRating,
      'utilizationRate': instance.utilizationRate,
    };

_TechnicianRevenue _$TechnicianRevenueFromJson(Map<String, dynamic> json) =>
    _TechnicianRevenue(
      technicianName: json['technicianName'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      dailyBreakdown: (json['dailyBreakdown'] as List<dynamic>)
          .map((e) => DailyRevenue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TechnicianRevenueToJson(_TechnicianRevenue instance) =>
    <String, dynamic>{
      'technicianName': instance.technicianName,
      'revenue': instance.revenue,
      'dailyBreakdown': instance.dailyBreakdown,
    };

_CustomerSegment _$CustomerSegmentFromJson(Map<String, dynamic> json) =>
    _CustomerSegment(
      segment: json['segment'] as String,
      count: (json['count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
      averageSpend: (json['averageSpend'] as num).toDouble(),
    );

Map<String, dynamic> _$CustomerSegmentToJson(_CustomerSegment instance) =>
    <String, dynamic>{
      'segment': instance.segment,
      'count': instance.count,
      'percentage': instance.percentage,
      'averageSpend': instance.averageSpend,
    };

_CustomerRetention _$CustomerRetentionFromJson(Map<String, dynamic> json) =>
    _CustomerRetention(
      month: DateTime.parse(json['month'] as String),
      retentionRate: (json['retentionRate'] as num).toDouble(),
      newCustomers: (json['newCustomers'] as num).toInt(),
      returningCustomers: (json['returningCustomers'] as num).toInt(),
    );

Map<String, dynamic> _$CustomerRetentionToJson(_CustomerRetention instance) =>
    <String, dynamic>{
      'month': instance.month.toIso8601String(),
      'retentionRate': instance.retentionRate,
      'newCustomers': instance.newCustomers,
      'returningCustomers': instance.returningCustomers,
    };

_HourlyBooking _$HourlyBookingFromJson(Map<String, dynamic> json) =>
    _HourlyBooking(
      hour: (json['hour'] as num).toInt(),
      bookingCount: (json['bookingCount'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$HourlyBookingToJson(_HourlyBooking instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'bookingCount': instance.bookingCount,
      'percentage': instance.percentage,
    };

_AppointmentType _$AppointmentTypeFromJson(Map<String, dynamic> json) =>
    _AppointmentType(
      type: json['type'] as String,
      count: (json['count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$AppointmentTypeToJson(_AppointmentType instance) =>
    <String, dynamic>{
      'type': instance.type,
      'count': instance.count,
      'percentage': instance.percentage,
    };

_PaymentTrend _$PaymentTrendFromJson(Map<String, dynamic> json) =>
    _PaymentTrend(
      date: DateTime.parse(json['date'] as String),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
    );

Map<String, dynamic> _$PaymentTrendToJson(_PaymentTrend instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
    };

_TrendPoint _$TrendPointFromJson(Map<String, dynamic> json) => _TrendPoint(
  date: DateTime.parse(json['date'] as String),
  value: (json['value'] as num).toDouble(),
);

Map<String, dynamic> _$TrendPointToJson(_TrendPoint instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'value': instance.value,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _socialSecurityNumberMeta =
      const VerificationMeta('socialSecurityNumber');
  @override
  late final GeneratedColumn<String> socialSecurityNumber =
      GeneratedColumn<String>(
        'social_security_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commissionRateMeta = const VerificationMeta(
    'commissionRate',
  );
  @override
  late final GeneratedColumn<double> commissionRate = GeneratedColumn<double>(
    'commission_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<double> hourlyRate = GeneratedColumn<double>(
    'hourly_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hireDateMeta = const VerificationMeta(
    'hireDate',
  );
  @override
  late final GeneratedColumn<String> hireDate = GeneratedColumn<String>(
    'hire_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clockedInAtMeta = const VerificationMeta(
    'clockedInAt',
  );
  @override
  late final GeneratedColumn<DateTime> clockedInAt = GeneratedColumn<DateTime>(
    'clocked_in_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clockedOutAtMeta = const VerificationMeta(
    'clockedOutAt',
  );
  @override
  late final GeneratedColumn<DateTime> clockedOutAt = GeneratedColumn<DateTime>(
    'clocked_out_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isClockedInMeta = const VerificationMeta(
    'isClockedIn',
  );
  @override
  late final GeneratedColumn<bool> isClockedIn = GeneratedColumn<bool>(
    'is_clocked_in',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_clocked_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pinMeta = const VerificationMeta('pin');
  @override
  late final GeneratedColumn<String> pin = GeneratedColumn<String>(
    'pin',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinSaltMeta = const VerificationMeta(
    'pinSalt',
  );
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
    'pin_salt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinCreatedAtMeta = const VerificationMeta(
    'pinCreatedAt',
  );
  @override
  late final GeneratedColumn<String> pinCreatedAt = GeneratedColumn<String>(
    'pin_created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinLastUsedAtMeta = const VerificationMeta(
    'pinLastUsedAt',
  );
  @override
  late final GeneratedColumn<String> pinLastUsedAt = GeneratedColumn<String>(
    'pin_last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    email,
    phone,
    socialSecurityNumber,
    role,
    commissionRate,
    hourlyRate,
    hireDate,
    isActive,
    createdAt,
    updatedAt,
    clockedInAt,
    clockedOutAt,
    isClockedIn,
    pin,
    pinSalt,
    pinCreatedAt,
    pinLastUsedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(
    Insertable<Employee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('social_security_number')) {
      context.handle(
        _socialSecurityNumberMeta,
        socialSecurityNumber.isAcceptableOrUnknown(
          data['social_security_number']!,
          _socialSecurityNumberMeta,
        ),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('commission_rate')) {
      context.handle(
        _commissionRateMeta,
        commissionRate.isAcceptableOrUnknown(
          data['commission_rate']!,
          _commissionRateMeta,
        ),
      );
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    }
    if (data.containsKey('hire_date')) {
      context.handle(
        _hireDateMeta,
        hireDate.isAcceptableOrUnknown(data['hire_date']!, _hireDateMeta),
      );
    } else if (isInserting) {
      context.missing(_hireDateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('clocked_in_at')) {
      context.handle(
        _clockedInAtMeta,
        clockedInAt.isAcceptableOrUnknown(
          data['clocked_in_at']!,
          _clockedInAtMeta,
        ),
      );
    }
    if (data.containsKey('clocked_out_at')) {
      context.handle(
        _clockedOutAtMeta,
        clockedOutAt.isAcceptableOrUnknown(
          data['clocked_out_at']!,
          _clockedOutAtMeta,
        ),
      );
    }
    if (data.containsKey('is_clocked_in')) {
      context.handle(
        _isClockedInMeta,
        isClockedIn.isAcceptableOrUnknown(
          data['is_clocked_in']!,
          _isClockedInMeta,
        ),
      );
    }
    if (data.containsKey('pin')) {
      context.handle(
        _pinMeta,
        pin.isAcceptableOrUnknown(data['pin']!, _pinMeta),
      );
    }
    if (data.containsKey('pin_salt')) {
      context.handle(
        _pinSaltMeta,
        pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta),
      );
    }
    if (data.containsKey('pin_created_at')) {
      context.handle(
        _pinCreatedAtMeta,
        pinCreatedAt.isAcceptableOrUnknown(
          data['pin_created_at']!,
          _pinCreatedAtMeta,
        ),
      );
    }
    if (data.containsKey('pin_last_used_at')) {
      context.handle(
        _pinLastUsedAtMeta,
        pinLastUsedAt.isAcceptableOrUnknown(
          data['pin_last_used_at']!,
          _pinLastUsedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      socialSecurityNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}social_security_number'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      commissionRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}commission_rate'],
      ),
      hourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hourly_rate'],
      ),
      hireDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hire_date'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
      clockedInAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clocked_in_at'],
      ),
      clockedOutAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}clocked_out_at'],
      ),
      isClockedIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_clocked_in'],
      ),
      pin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin'],
      ),
      pinSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_salt'],
      ),
      pinCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_created_at'],
      ),
      pinLastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_last_used_at'],
      ),
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final int id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? socialSecurityNumber;
  final String role;
  final double? commissionRate;
  final double? hourlyRate;
  final String hireDate;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final DateTime? clockedInAt;
  final DateTime? clockedOutAt;
  final bool? isClockedIn;
  final String? pin;
  final String? pinSalt;
  final String? pinCreatedAt;
  final String? pinLastUsedAt;
  const Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.socialSecurityNumber,
    required this.role,
    this.commissionRate,
    this.hourlyRate,
    required this.hireDate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.clockedInAt,
    this.clockedOutAt,
    this.isClockedIn,
    this.pin,
    this.pinSalt,
    this.pinCreatedAt,
    this.pinLastUsedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || socialSecurityNumber != null) {
      map['social_security_number'] = Variable<String>(socialSecurityNumber);
    }
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || commissionRate != null) {
      map['commission_rate'] = Variable<double>(commissionRate);
    }
    if (!nullToAbsent || hourlyRate != null) {
      map['hourly_rate'] = Variable<double>(hourlyRate);
    }
    map['hire_date'] = Variable<String>(hireDate);
    if (!nullToAbsent || isActive != null) {
      map['is_active'] = Variable<bool>(isActive);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || clockedInAt != null) {
      map['clocked_in_at'] = Variable<DateTime>(clockedInAt);
    }
    if (!nullToAbsent || clockedOutAt != null) {
      map['clocked_out_at'] = Variable<DateTime>(clockedOutAt);
    }
    if (!nullToAbsent || isClockedIn != null) {
      map['is_clocked_in'] = Variable<bool>(isClockedIn);
    }
    if (!nullToAbsent || pin != null) {
      map['pin'] = Variable<String>(pin);
    }
    if (!nullToAbsent || pinSalt != null) {
      map['pin_salt'] = Variable<String>(pinSalt);
    }
    if (!nullToAbsent || pinCreatedAt != null) {
      map['pin_created_at'] = Variable<String>(pinCreatedAt);
    }
    if (!nullToAbsent || pinLastUsedAt != null) {
      map['pin_last_used_at'] = Variable<String>(pinLastUsedAt);
    }
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      socialSecurityNumber: socialSecurityNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(socialSecurityNumber),
      role: Value(role),
      commissionRate: commissionRate == null && nullToAbsent
          ? const Value.absent()
          : Value(commissionRate),
      hourlyRate: hourlyRate == null && nullToAbsent
          ? const Value.absent()
          : Value(hourlyRate),
      hireDate: Value(hireDate),
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      clockedInAt: clockedInAt == null && nullToAbsent
          ? const Value.absent()
          : Value(clockedInAt),
      clockedOutAt: clockedOutAt == null && nullToAbsent
          ? const Value.absent()
          : Value(clockedOutAt),
      isClockedIn: isClockedIn == null && nullToAbsent
          ? const Value.absent()
          : Value(isClockedIn),
      pin: pin == null && nullToAbsent ? const Value.absent() : Value(pin),
      pinSalt: pinSalt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinSalt),
      pinCreatedAt: pinCreatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinCreatedAt),
      pinLastUsedAt: pinLastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinLastUsedAt),
    );
  }

  factory Employee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      socialSecurityNumber: serializer.fromJson<String?>(
        json['socialSecurityNumber'],
      ),
      role: serializer.fromJson<String>(json['role']),
      commissionRate: serializer.fromJson<double?>(json['commissionRate']),
      hourlyRate: serializer.fromJson<double?>(json['hourlyRate']),
      hireDate: serializer.fromJson<String>(json['hireDate']),
      isActive: serializer.fromJson<bool?>(json['isActive']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      clockedInAt: serializer.fromJson<DateTime?>(json['clockedInAt']),
      clockedOutAt: serializer.fromJson<DateTime?>(json['clockedOutAt']),
      isClockedIn: serializer.fromJson<bool?>(json['isClockedIn']),
      pin: serializer.fromJson<String?>(json['pin']),
      pinSalt: serializer.fromJson<String?>(json['pinSalt']),
      pinCreatedAt: serializer.fromJson<String?>(json['pinCreatedAt']),
      pinLastUsedAt: serializer.fromJson<String?>(json['pinLastUsedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'socialSecurityNumber': serializer.toJson<String?>(socialSecurityNumber),
      'role': serializer.toJson<String>(role),
      'commissionRate': serializer.toJson<double?>(commissionRate),
      'hourlyRate': serializer.toJson<double?>(hourlyRate),
      'hireDate': serializer.toJson<String>(hireDate),
      'isActive': serializer.toJson<bool?>(isActive),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'clockedInAt': serializer.toJson<DateTime?>(clockedInAt),
      'clockedOutAt': serializer.toJson<DateTime?>(clockedOutAt),
      'isClockedIn': serializer.toJson<bool?>(isClockedIn),
      'pin': serializer.toJson<String?>(pin),
      'pinSalt': serializer.toJson<String?>(pinSalt),
      'pinCreatedAt': serializer.toJson<String?>(pinCreatedAt),
      'pinLastUsedAt': serializer.toJson<String?>(pinLastUsedAt),
    };
  }

  Employee copyWith({
    int? id,
    String? firstName,
    String? lastName,
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> socialSecurityNumber = const Value.absent(),
    String? role,
    Value<double?> commissionRate = const Value.absent(),
    Value<double?> hourlyRate = const Value.absent(),
    String? hireDate,
    Value<bool?> isActive = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    Value<String?> updatedAt = const Value.absent(),
    Value<DateTime?> clockedInAt = const Value.absent(),
    Value<DateTime?> clockedOutAt = const Value.absent(),
    Value<bool?> isClockedIn = const Value.absent(),
    Value<String?> pin = const Value.absent(),
    Value<String?> pinSalt = const Value.absent(),
    Value<String?> pinCreatedAt = const Value.absent(),
    Value<String?> pinLastUsedAt = const Value.absent(),
  }) => Employee(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    socialSecurityNumber: socialSecurityNumber.present
        ? socialSecurityNumber.value
        : this.socialSecurityNumber,
    role: role ?? this.role,
    commissionRate: commissionRate.present
        ? commissionRate.value
        : this.commissionRate,
    hourlyRate: hourlyRate.present ? hourlyRate.value : this.hourlyRate,
    hireDate: hireDate ?? this.hireDate,
    isActive: isActive.present ? isActive.value : this.isActive,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    clockedInAt: clockedInAt.present ? clockedInAt.value : this.clockedInAt,
    clockedOutAt: clockedOutAt.present ? clockedOutAt.value : this.clockedOutAt,
    isClockedIn: isClockedIn.present ? isClockedIn.value : this.isClockedIn,
    pin: pin.present ? pin.value : this.pin,
    pinSalt: pinSalt.present ? pinSalt.value : this.pinSalt,
    pinCreatedAt: pinCreatedAt.present ? pinCreatedAt.value : this.pinCreatedAt,
    pinLastUsedAt: pinLastUsedAt.present
        ? pinLastUsedAt.value
        : this.pinLastUsedAt,
  );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      socialSecurityNumber: data.socialSecurityNumber.present
          ? data.socialSecurityNumber.value
          : this.socialSecurityNumber,
      role: data.role.present ? data.role.value : this.role,
      commissionRate: data.commissionRate.present
          ? data.commissionRate.value
          : this.commissionRate,
      hourlyRate: data.hourlyRate.present
          ? data.hourlyRate.value
          : this.hourlyRate,
      hireDate: data.hireDate.present ? data.hireDate.value : this.hireDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      clockedInAt: data.clockedInAt.present
          ? data.clockedInAt.value
          : this.clockedInAt,
      clockedOutAt: data.clockedOutAt.present
          ? data.clockedOutAt.value
          : this.clockedOutAt,
      isClockedIn: data.isClockedIn.present
          ? data.isClockedIn.value
          : this.isClockedIn,
      pin: data.pin.present ? data.pin.value : this.pin,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      pinCreatedAt: data.pinCreatedAt.present
          ? data.pinCreatedAt.value
          : this.pinCreatedAt,
      pinLastUsedAt: data.pinLastUsedAt.present
          ? data.pinLastUsedAt.value
          : this.pinLastUsedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('socialSecurityNumber: $socialSecurityNumber, ')
          ..write('role: $role, ')
          ..write('commissionRate: $commissionRate, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('hireDate: $hireDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clockedInAt: $clockedInAt, ')
          ..write('clockedOutAt: $clockedOutAt, ')
          ..write('isClockedIn: $isClockedIn, ')
          ..write('pin: $pin, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinCreatedAt: $pinCreatedAt, ')
          ..write('pinLastUsedAt: $pinLastUsedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastName,
    email,
    phone,
    socialSecurityNumber,
    role,
    commissionRate,
    hourlyRate,
    hireDate,
    isActive,
    createdAt,
    updatedAt,
    clockedInAt,
    clockedOutAt,
    isClockedIn,
    pin,
    pinSalt,
    pinCreatedAt,
    pinLastUsedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.socialSecurityNumber == this.socialSecurityNumber &&
          other.role == this.role &&
          other.commissionRate == this.commissionRate &&
          other.hourlyRate == this.hourlyRate &&
          other.hireDate == this.hireDate &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.clockedInAt == this.clockedInAt &&
          other.clockedOutAt == this.clockedOutAt &&
          other.isClockedIn == this.isClockedIn &&
          other.pin == this.pin &&
          other.pinSalt == this.pinSalt &&
          other.pinCreatedAt == this.pinCreatedAt &&
          other.pinLastUsedAt == this.pinLastUsedAt);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> socialSecurityNumber;
  final Value<String> role;
  final Value<double?> commissionRate;
  final Value<double?> hourlyRate;
  final Value<String> hireDate;
  final Value<bool?> isActive;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<DateTime?> clockedInAt;
  final Value<DateTime?> clockedOutAt;
  final Value<bool?> isClockedIn;
  final Value<String?> pin;
  final Value<String?> pinSalt;
  final Value<String?> pinCreatedAt;
  final Value<String?> pinLastUsedAt;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.socialSecurityNumber = const Value.absent(),
    this.role = const Value.absent(),
    this.commissionRate = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.hireDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clockedInAt = const Value.absent(),
    this.clockedOutAt = const Value.absent(),
    this.isClockedIn = const Value.absent(),
    this.pin = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinCreatedAt = const Value.absent(),
    this.pinLastUsedAt = const Value.absent(),
  });
  EmployeesCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String lastName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.socialSecurityNumber = const Value.absent(),
    required String role,
    this.commissionRate = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    required String hireDate,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clockedInAt = const Value.absent(),
    this.clockedOutAt = const Value.absent(),
    this.isClockedIn = const Value.absent(),
    this.pin = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinCreatedAt = const Value.absent(),
    this.pinLastUsedAt = const Value.absent(),
  }) : firstName = Value(firstName),
       lastName = Value(lastName),
       role = Value(role),
       hireDate = Value(hireDate);
  static Insertable<Employee> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? socialSecurityNumber,
    Expression<String>? role,
    Expression<double>? commissionRate,
    Expression<double>? hourlyRate,
    Expression<String>? hireDate,
    Expression<bool>? isActive,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<DateTime>? clockedInAt,
    Expression<DateTime>? clockedOutAt,
    Expression<bool>? isClockedIn,
    Expression<String>? pin,
    Expression<String>? pinSalt,
    Expression<String>? pinCreatedAt,
    Expression<String>? pinLastUsedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (socialSecurityNumber != null)
        'social_security_number': socialSecurityNumber,
      if (role != null) 'role': role,
      if (commissionRate != null) 'commission_rate': commissionRate,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (hireDate != null) 'hire_date': hireDate,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (clockedInAt != null) 'clocked_in_at': clockedInAt,
      if (clockedOutAt != null) 'clocked_out_at': clockedOutAt,
      if (isClockedIn != null) 'is_clocked_in': isClockedIn,
      if (pin != null) 'pin': pin,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (pinCreatedAt != null) 'pin_created_at': pinCreatedAt,
      if (pinLastUsedAt != null) 'pin_last_used_at': pinLastUsedAt,
    });
  }

  EmployeesCompanion copyWith({
    Value<int>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? socialSecurityNumber,
    Value<String>? role,
    Value<double?>? commissionRate,
    Value<double?>? hourlyRate,
    Value<String>? hireDate,
    Value<bool?>? isActive,
    Value<String?>? createdAt,
    Value<String?>? updatedAt,
    Value<DateTime?>? clockedInAt,
    Value<DateTime?>? clockedOutAt,
    Value<bool?>? isClockedIn,
    Value<String?>? pin,
    Value<String?>? pinSalt,
    Value<String?>? pinCreatedAt,
    Value<String?>? pinLastUsedAt,
  }) {
    return EmployeesCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      socialSecurityNumber: socialSecurityNumber ?? this.socialSecurityNumber,
      role: role ?? this.role,
      commissionRate: commissionRate ?? this.commissionRate,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      hireDate: hireDate ?? this.hireDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clockedInAt: clockedInAt ?? this.clockedInAt,
      clockedOutAt: clockedOutAt ?? this.clockedOutAt,
      isClockedIn: isClockedIn ?? this.isClockedIn,
      pin: pin ?? this.pin,
      pinSalt: pinSalt ?? this.pinSalt,
      pinCreatedAt: pinCreatedAt ?? this.pinCreatedAt,
      pinLastUsedAt: pinLastUsedAt ?? this.pinLastUsedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (socialSecurityNumber.present) {
      map['social_security_number'] = Variable<String>(
        socialSecurityNumber.value,
      );
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (commissionRate.present) {
      map['commission_rate'] = Variable<double>(commissionRate.value);
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<double>(hourlyRate.value);
    }
    if (hireDate.present) {
      map['hire_date'] = Variable<String>(hireDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (clockedInAt.present) {
      map['clocked_in_at'] = Variable<DateTime>(clockedInAt.value);
    }
    if (clockedOutAt.present) {
      map['clocked_out_at'] = Variable<DateTime>(clockedOutAt.value);
    }
    if (isClockedIn.present) {
      map['is_clocked_in'] = Variable<bool>(isClockedIn.value);
    }
    if (pin.present) {
      map['pin'] = Variable<String>(pin.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (pinCreatedAt.present) {
      map['pin_created_at'] = Variable<String>(pinCreatedAt.value);
    }
    if (pinLastUsedAt.present) {
      map['pin_last_used_at'] = Variable<String>(pinLastUsedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('socialSecurityNumber: $socialSecurityNumber, ')
          ..write('role: $role, ')
          ..write('commissionRate: $commissionRate, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('hireDate: $hireDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clockedInAt: $clockedInAt, ')
          ..write('clockedOutAt: $clockedOutAt, ')
          ..write('isClockedIn: $isClockedIn, ')
          ..write('pin: $pin, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinCreatedAt: $pinCreatedAt, ')
          ..write('pinLastUsedAt: $pinLastUsedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<String> dateOfBirth = GeneratedColumn<String>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zipCodeMeta = const VerificationMeta(
    'zipCode',
  );
  @override
  late final GeneratedColumn<String> zipCode = GeneratedColumn<String>(
    'zip_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loyaltyPointsMeta = const VerificationMeta(
    'loyaltyPoints',
  );
  @override
  late final GeneratedColumn<int> loyaltyPoints = GeneratedColumn<int>(
    'loyalty_points',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastVisitMeta = const VerificationMeta(
    'lastVisit',
  );
  @override
  late final GeneratedColumn<String> lastVisit = GeneratedColumn<String>(
    'last_visit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredTechnicianMeta =
      const VerificationMeta('preferredTechnician');
  @override
  late final GeneratedColumn<String> preferredTechnician =
      GeneratedColumn<String>(
        'preferred_technician',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailOptInMeta = const VerificationMeta(
    'emailOptIn',
  );
  @override
  late final GeneratedColumn<int> emailOptIn = GeneratedColumn<int>(
    'email_opt_in',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _smsOptInMeta = const VerificationMeta(
    'smsOptIn',
  );
  @override
  late final GeneratedColumn<int> smsOptIn = GeneratedColumn<int>(
    'sms_opt_in',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    lastName,
    email,
    phone,
    dateOfBirth,
    gender,
    address,
    city,
    state,
    zipCode,
    loyaltyPoints,
    lastVisit,
    preferredTechnician,
    notes,
    allergies,
    emailOptIn,
    smsOptIn,
    status,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('zip_code')) {
      context.handle(
        _zipCodeMeta,
        zipCode.isAcceptableOrUnknown(data['zip_code']!, _zipCodeMeta),
      );
    }
    if (data.containsKey('loyalty_points')) {
      context.handle(
        _loyaltyPointsMeta,
        loyaltyPoints.isAcceptableOrUnknown(
          data['loyalty_points']!,
          _loyaltyPointsMeta,
        ),
      );
    }
    if (data.containsKey('last_visit')) {
      context.handle(
        _lastVisitMeta,
        lastVisit.isAcceptableOrUnknown(data['last_visit']!, _lastVisitMeta),
      );
    }
    if (data.containsKey('preferred_technician')) {
      context.handle(
        _preferredTechnicianMeta,
        preferredTechnician.isAcceptableOrUnknown(
          data['preferred_technician']!,
          _preferredTechnicianMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    }
    if (data.containsKey('email_opt_in')) {
      context.handle(
        _emailOptInMeta,
        emailOptIn.isAcceptableOrUnknown(
          data['email_opt_in']!,
          _emailOptInMeta,
        ),
      );
    }
    if (data.containsKey('sms_opt_in')) {
      context.handle(
        _smsOptInMeta,
        smsOptIn.isAcceptableOrUnknown(data['sms_opt_in']!, _smsOptInMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_of_birth'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      ),
      zipCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zip_code'],
      ),
      loyaltyPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}loyalty_points'],
      ),
      lastVisit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_visit'],
      ),
      preferredTechnician: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_technician'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      ),
      emailOptIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}email_opt_in'],
      ),
      smsOptIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sms_opt_in'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final int? loyaltyPoints;
  final String? lastVisit;
  final String? preferredTechnician;
  final String? notes;
  final String? allergies;
  final int? emailOptIn;
  final int? smsOptIn;
  final String? status;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;
  const Customer({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    this.loyaltyPoints,
    this.lastVisit,
    this.preferredTechnician,
    this.notes,
    this.allergies,
    this.emailOptIn,
    this.smsOptIn,
    this.status,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<String>(dateOfBirth);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || state != null) {
      map['state'] = Variable<String>(state);
    }
    if (!nullToAbsent || zipCode != null) {
      map['zip_code'] = Variable<String>(zipCode);
    }
    if (!nullToAbsent || loyaltyPoints != null) {
      map['loyalty_points'] = Variable<int>(loyaltyPoints);
    }
    if (!nullToAbsent || lastVisit != null) {
      map['last_visit'] = Variable<String>(lastVisit);
    }
    if (!nullToAbsent || preferredTechnician != null) {
      map['preferred_technician'] = Variable<String>(preferredTechnician);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || allergies != null) {
      map['allergies'] = Variable<String>(allergies);
    }
    if (!nullToAbsent || emailOptIn != null) {
      map['email_opt_in'] = Variable<int>(emailOptIn);
    }
    if (!nullToAbsent || smsOptIn != null) {
      map['sms_opt_in'] = Variable<int>(smsOptIn);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || isActive != null) {
      map['is_active'] = Variable<int>(isActive);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      state: state == null && nullToAbsent
          ? const Value.absent()
          : Value(state),
      zipCode: zipCode == null && nullToAbsent
          ? const Value.absent()
          : Value(zipCode),
      loyaltyPoints: loyaltyPoints == null && nullToAbsent
          ? const Value.absent()
          : Value(loyaltyPoints),
      lastVisit: lastVisit == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVisit),
      preferredTechnician: preferredTechnician == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredTechnician),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      allergies: allergies == null && nullToAbsent
          ? const Value.absent()
          : Value(allergies),
      emailOptIn: emailOptIn == null && nullToAbsent
          ? const Value.absent()
          : Value(emailOptIn),
      smsOptIn: smsOptIn == null && nullToAbsent
          ? const Value.absent()
          : Value(smsOptIn),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
      dateOfBirth: serializer.fromJson<String?>(json['dateOfBirth']),
      gender: serializer.fromJson<String?>(json['gender']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      zipCode: serializer.fromJson<String?>(json['zipCode']),
      loyaltyPoints: serializer.fromJson<int?>(json['loyaltyPoints']),
      lastVisit: serializer.fromJson<String?>(json['lastVisit']),
      preferredTechnician: serializer.fromJson<String?>(
        json['preferredTechnician'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      allergies: serializer.fromJson<String?>(json['allergies']),
      emailOptIn: serializer.fromJson<int?>(json['emailOptIn']),
      smsOptIn: serializer.fromJson<int?>(json['smsOptIn']),
      status: serializer.fromJson<String?>(json['status']),
      isActive: serializer.fromJson<int?>(json['isActive']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
      'dateOfBirth': serializer.toJson<String?>(dateOfBirth),
      'gender': serializer.toJson<String?>(gender),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'zipCode': serializer.toJson<String?>(zipCode),
      'loyaltyPoints': serializer.toJson<int?>(loyaltyPoints),
      'lastVisit': serializer.toJson<String?>(lastVisit),
      'preferredTechnician': serializer.toJson<String?>(preferredTechnician),
      'notes': serializer.toJson<String?>(notes),
      'allergies': serializer.toJson<String?>(allergies),
      'emailOptIn': serializer.toJson<int?>(emailOptIn),
      'smsOptIn': serializer.toJson<int?>(smsOptIn),
      'status': serializer.toJson<String?>(status),
      'isActive': serializer.toJson<int?>(isActive),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  Customer copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> dateOfBirth = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> zipCode = const Value.absent(),
    Value<int?> loyaltyPoints = const Value.absent(),
    Value<String?> lastVisit = const Value.absent(),
    Value<String?> preferredTechnician = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> allergies = const Value.absent(),
    Value<int?> emailOptIn = const Value.absent(),
    Value<int?> smsOptIn = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<int?> isActive = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    Value<String?> updatedAt = const Value.absent(),
  }) => Customer(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    gender: gender.present ? gender.value : this.gender,
    address: address.present ? address.value : this.address,
    city: city.present ? city.value : this.city,
    state: state.present ? state.value : this.state,
    zipCode: zipCode.present ? zipCode.value : this.zipCode,
    loyaltyPoints: loyaltyPoints.present
        ? loyaltyPoints.value
        : this.loyaltyPoints,
    lastVisit: lastVisit.present ? lastVisit.value : this.lastVisit,
    preferredTechnician: preferredTechnician.present
        ? preferredTechnician.value
        : this.preferredTechnician,
    notes: notes.present ? notes.value : this.notes,
    allergies: allergies.present ? allergies.value : this.allergies,
    emailOptIn: emailOptIn.present ? emailOptIn.value : this.emailOptIn,
    smsOptIn: smsOptIn.present ? smsOptIn.value : this.smsOptIn,
    status: status.present ? status.value : this.status,
    isActive: isActive.present ? isActive.value : this.isActive,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      gender: data.gender.present ? data.gender.value : this.gender,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      state: data.state.present ? data.state.value : this.state,
      zipCode: data.zipCode.present ? data.zipCode.value : this.zipCode,
      loyaltyPoints: data.loyaltyPoints.present
          ? data.loyaltyPoints.value
          : this.loyaltyPoints,
      lastVisit: data.lastVisit.present ? data.lastVisit.value : this.lastVisit,
      preferredTechnician: data.preferredTechnician.present
          ? data.preferredTechnician.value
          : this.preferredTechnician,
      notes: data.notes.present ? data.notes.value : this.notes,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      emailOptIn: data.emailOptIn.present
          ? data.emailOptIn.value
          : this.emailOptIn,
      smsOptIn: data.smsOptIn.present ? data.smsOptIn.value : this.smsOptIn,
      status: data.status.present ? data.status.value : this.status,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('zipCode: $zipCode, ')
          ..write('loyaltyPoints: $loyaltyPoints, ')
          ..write('lastVisit: $lastVisit, ')
          ..write('preferredTechnician: $preferredTechnician, ')
          ..write('notes: $notes, ')
          ..write('allergies: $allergies, ')
          ..write('emailOptIn: $emailOptIn, ')
          ..write('smsOptIn: $smsOptIn, ')
          ..write('status: $status, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    firstName,
    lastName,
    email,
    phone,
    dateOfBirth,
    gender,
    address,
    city,
    state,
    zipCode,
    loyaltyPoints,
    lastVisit,
    preferredTechnician,
    notes,
    allergies,
    emailOptIn,
    smsOptIn,
    status,
    isActive,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.email == this.email &&
          other.phone == this.phone &&
          other.dateOfBirth == this.dateOfBirth &&
          other.gender == this.gender &&
          other.address == this.address &&
          other.city == this.city &&
          other.state == this.state &&
          other.zipCode == this.zipCode &&
          other.loyaltyPoints == this.loyaltyPoints &&
          other.lastVisit == this.lastVisit &&
          other.preferredTechnician == this.preferredTechnician &&
          other.notes == this.notes &&
          other.allergies == this.allergies &&
          other.emailOptIn == this.emailOptIn &&
          other.smsOptIn == this.smsOptIn &&
          other.status == this.status &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> email;
  final Value<String?> phone;
  final Value<String?> dateOfBirth;
  final Value<String?> gender;
  final Value<String?> address;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> zipCode;
  final Value<int?> loyaltyPoints;
  final Value<String?> lastVisit;
  final Value<String?> preferredTechnician;
  final Value<String?> notes;
  final Value<String?> allergies;
  final Value<int?> emailOptIn;
  final Value<int?> smsOptIn;
  final Value<String?> status;
  final Value<int?> isActive;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.loyaltyPoints = const Value.absent(),
    this.lastVisit = const Value.absent(),
    this.preferredTechnician = const Value.absent(),
    this.notes = const Value.absent(),
    this.allergies = const Value.absent(),
    this.emailOptIn = const Value.absent(),
    this.smsOptIn = const Value.absent(),
    this.status = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.gender = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.state = const Value.absent(),
    this.zipCode = const Value.absent(),
    this.loyaltyPoints = const Value.absent(),
    this.lastVisit = const Value.absent(),
    this.preferredTechnician = const Value.absent(),
    this.notes = const Value.absent(),
    this.allergies = const Value.absent(),
    this.emailOptIn = const Value.absent(),
    this.smsOptIn = const Value.absent(),
    this.status = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       firstName = Value(firstName),
       lastName = Value(lastName);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? dateOfBirth,
    Expression<String>? gender,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? zipCode,
    Expression<int>? loyaltyPoints,
    Expression<String>? lastVisit,
    Expression<String>? preferredTechnician,
    Expression<String>? notes,
    Expression<String>? allergies,
    Expression<int>? emailOptIn,
    Expression<int>? smsOptIn,
    Expression<String>? status,
    Expression<int>? isActive,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (gender != null) 'gender': gender,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (zipCode != null) 'zip_code': zipCode,
      if (loyaltyPoints != null) 'loyalty_points': loyaltyPoints,
      if (lastVisit != null) 'last_visit': lastVisit,
      if (preferredTechnician != null)
        'preferred_technician': preferredTechnician,
      if (notes != null) 'notes': notes,
      if (allergies != null) 'allergies': allergies,
      if (emailOptIn != null) 'email_opt_in': emailOptIn,
      if (smsOptIn != null) 'sms_opt_in': smsOptIn,
      if (status != null) 'status': status,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String?>? email,
    Value<String?>? phone,
    Value<String?>? dateOfBirth,
    Value<String?>? gender,
    Value<String?>? address,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? zipCode,
    Value<int?>? loyaltyPoints,
    Value<String?>? lastVisit,
    Value<String?>? preferredTechnician,
    Value<String?>? notes,
    Value<String?>? allergies,
    Value<int?>? emailOptIn,
    Value<int?>? smsOptIn,
    Value<String?>? status,
    Value<int?>? isActive,
    Value<String?>? createdAt,
    Value<String?>? updatedAt,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      lastVisit: lastVisit ?? this.lastVisit,
      preferredTechnician: preferredTechnician ?? this.preferredTechnician,
      notes: notes ?? this.notes,
      allergies: allergies ?? this.allergies,
      emailOptIn: emailOptIn ?? this.emailOptIn,
      smsOptIn: smsOptIn ?? this.smsOptIn,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<String>(dateOfBirth.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (zipCode.present) {
      map['zip_code'] = Variable<String>(zipCode.value);
    }
    if (loyaltyPoints.present) {
      map['loyalty_points'] = Variable<int>(loyaltyPoints.value);
    }
    if (lastVisit.present) {
      map['last_visit'] = Variable<String>(lastVisit.value);
    }
    if (preferredTechnician.present) {
      map['preferred_technician'] = Variable<String>(preferredTechnician.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (emailOptIn.present) {
      map['email_opt_in'] = Variable<int>(emailOptIn.value);
    }
    if (smsOptIn.present) {
      map['sms_opt_in'] = Variable<int>(smsOptIn.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('email: $email, ')
          ..write('phone: $phone, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('gender: $gender, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('state: $state, ')
          ..write('zipCode: $zipCode, ')
          ..write('loyaltyPoints: $loyaltyPoints, ')
          ..write('lastVisit: $lastVisit, ')
          ..write('preferredTechnician: $preferredTechnician, ')
          ..write('notes: $notes, ')
          ..write('allergies: $allergies, ')
          ..write('emailOptIn: $emailOptIn, ')
          ..write('smsOptIn: $smsOptIn, ')
          ..write('status: $status, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TicketsTable extends Tickets with TableInfo<$TicketsTable, Ticket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ticketNumberMeta = const VerificationMeta(
    'ticketNumber',
  );
  @override
  late final GeneratedColumn<int> ticketNumber = GeneratedColumn<int>(
    'ticket_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<
    List<Map<String, dynamic>>,
    String
  >
  services = GeneratedColumn<String>(
    'services',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<Map<String, dynamic>>>($TicketsTable.$converterservices);
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _businessDateMeta = const VerificationMeta(
    'businessDate',
  );
  @override
  late final GeneratedColumn<String> businessDate = GeneratedColumn<String>(
    'business_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInTimeMeta = const VerificationMeta(
    'checkInTime',
  );
  @override
  late final GeneratedColumn<String> checkInTime = GeneratedColumn<String>(
    'check_in_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedTechnicianIdMeta =
      const VerificationMeta('assignedTechnicianId');
  @override
  late final GeneratedColumn<int> assignedTechnicianId = GeneratedColumn<int>(
    'assigned_technician_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isGroupServiceMeta = const VerificationMeta(
    'isGroupService',
  );
  @override
  late final GeneratedColumn<int> isGroupService = GeneratedColumn<int>(
    'is_group_service',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupSizeMeta = const VerificationMeta(
    'groupSize',
  );
  @override
  late final GeneratedColumn<int> groupSize = GeneratedColumn<int>(
    'group_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
    'appointment_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    employeeId,
    ticketNumber,
    customerName,
    services,
    priority,
    notes,
    status,
    createdAt,
    updatedAt,
    businessDate,
    checkInTime,
    assignedTechnicianId,
    totalAmount,
    paymentStatus,
    isGroupService,
    groupSize,
    appointmentId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tickets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ticket> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('ticket_number')) {
      context.handle(
        _ticketNumberMeta,
        ticketNumber.isAcceptableOrUnknown(
          data['ticket_number']!,
          _ticketNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ticketNumberMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('business_date')) {
      context.handle(
        _businessDateMeta,
        businessDate.isAcceptableOrUnknown(
          data['business_date']!,
          _businessDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessDateMeta);
    }
    if (data.containsKey('check_in_time')) {
      context.handle(
        _checkInTimeMeta,
        checkInTime.isAcceptableOrUnknown(
          data['check_in_time']!,
          _checkInTimeMeta,
        ),
      );
    }
    if (data.containsKey('assigned_technician_id')) {
      context.handle(
        _assignedTechnicianIdMeta,
        assignedTechnicianId.isAcceptableOrUnknown(
          data['assigned_technician_id']!,
          _assignedTechnicianIdMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('payment_status')) {
      context.handle(
        _paymentStatusMeta,
        paymentStatus.isAcceptableOrUnknown(
          data['payment_status']!,
          _paymentStatusMeta,
        ),
      );
    }
    if (data.containsKey('is_group_service')) {
      context.handle(
        _isGroupServiceMeta,
        isGroupService.isAcceptableOrUnknown(
          data['is_group_service']!,
          _isGroupServiceMeta,
        ),
      );
    }
    if (data.containsKey('group_size')) {
      context.handle(
        _groupSizeMeta,
        groupSize.isAcceptableOrUnknown(data['group_size']!, _groupSizeMeta),
      );
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ticket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ticket(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      ticketNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ticket_number'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      services: $TicketsTable.$converterservices.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}services'],
        )!,
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
      businessDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_date'],
      )!,
      checkInTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}check_in_time'],
      ),
      assignedTechnicianId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_technician_id'],
      ),
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      ),
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      ),
      isGroupService: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_group_service'],
      ),
      groupSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_size'],
      ),
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_id'],
      ),
    );
  }

  @override
  $TicketsTable createAlias(String alias) {
    return $TicketsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Map<String, dynamic>>, String> $converterservices =
      const ServicesJsonConverter();
}

class Ticket extends DataClass implements Insertable<Ticket> {
  final String id;
  final String? customerId;
  final int employeeId;
  final int ticketNumber;
  final String customerName;
  final List<Map<String, dynamic>> services;
  final int? priority;
  final String? notes;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String businessDate;
  final String? checkInTime;
  final int? assignedTechnicianId;
  final double? totalAmount;
  final String? paymentStatus;
  final int? isGroupService;
  final int? groupSize;
  final String? appointmentId;
  const Ticket({
    required this.id,
    this.customerId,
    required this.employeeId,
    required this.ticketNumber,
    required this.customerName,
    required this.services,
    this.priority,
    this.notes,
    this.status,
    this.createdAt,
    this.updatedAt,
    required this.businessDate,
    this.checkInTime,
    this.assignedTechnicianId,
    this.totalAmount,
    this.paymentStatus,
    this.isGroupService,
    this.groupSize,
    this.appointmentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['employee_id'] = Variable<int>(employeeId);
    map['ticket_number'] = Variable<int>(ticketNumber);
    map['customer_name'] = Variable<String>(customerName);
    {
      map['services'] = Variable<String>(
        $TicketsTable.$converterservices.toSql(services),
      );
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<int>(priority);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    map['business_date'] = Variable<String>(businessDate);
    if (!nullToAbsent || checkInTime != null) {
      map['check_in_time'] = Variable<String>(checkInTime);
    }
    if (!nullToAbsent || assignedTechnicianId != null) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId);
    }
    if (!nullToAbsent || totalAmount != null) {
      map['total_amount'] = Variable<double>(totalAmount);
    }
    if (!nullToAbsent || paymentStatus != null) {
      map['payment_status'] = Variable<String>(paymentStatus);
    }
    if (!nullToAbsent || isGroupService != null) {
      map['is_group_service'] = Variable<int>(isGroupService);
    }
    if (!nullToAbsent || groupSize != null) {
      map['group_size'] = Variable<int>(groupSize);
    }
    if (!nullToAbsent || appointmentId != null) {
      map['appointment_id'] = Variable<String>(appointmentId);
    }
    return map;
  }

  TicketsCompanion toCompanion(bool nullToAbsent) {
    return TicketsCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      employeeId: Value(employeeId),
      ticketNumber: Value(ticketNumber),
      customerName: Value(customerName),
      services: Value(services),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      businessDate: Value(businessDate),
      checkInTime: checkInTime == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInTime),
      assignedTechnicianId: assignedTechnicianId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedTechnicianId),
      totalAmount: totalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmount),
      paymentStatus: paymentStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentStatus),
      isGroupService: isGroupService == null && nullToAbsent
          ? const Value.absent()
          : Value(isGroupService),
      groupSize: groupSize == null && nullToAbsent
          ? const Value.absent()
          : Value(groupSize),
      appointmentId: appointmentId == null && nullToAbsent
          ? const Value.absent()
          : Value(appointmentId),
    );
  }

  factory Ticket.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ticket(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      ticketNumber: serializer.fromJson<int>(json['ticketNumber']),
      customerName: serializer.fromJson<String>(json['customerName']),
      services: serializer.fromJson<List<Map<String, dynamic>>>(
        json['services'],
      ),
      priority: serializer.fromJson<int?>(json['priority']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String?>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
      businessDate: serializer.fromJson<String>(json['businessDate']),
      checkInTime: serializer.fromJson<String?>(json['checkInTime']),
      assignedTechnicianId: serializer.fromJson<int?>(
        json['assignedTechnicianId'],
      ),
      totalAmount: serializer.fromJson<double?>(json['totalAmount']),
      paymentStatus: serializer.fromJson<String?>(json['paymentStatus']),
      isGroupService: serializer.fromJson<int?>(json['isGroupService']),
      groupSize: serializer.fromJson<int?>(json['groupSize']),
      appointmentId: serializer.fromJson<String?>(json['appointmentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String?>(customerId),
      'employeeId': serializer.toJson<int>(employeeId),
      'ticketNumber': serializer.toJson<int>(ticketNumber),
      'customerName': serializer.toJson<String>(customerName),
      'services': serializer.toJson<List<Map<String, dynamic>>>(services),
      'priority': serializer.toJson<int?>(priority),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String?>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
      'businessDate': serializer.toJson<String>(businessDate),
      'checkInTime': serializer.toJson<String?>(checkInTime),
      'assignedTechnicianId': serializer.toJson<int?>(assignedTechnicianId),
      'totalAmount': serializer.toJson<double?>(totalAmount),
      'paymentStatus': serializer.toJson<String?>(paymentStatus),
      'isGroupService': serializer.toJson<int?>(isGroupService),
      'groupSize': serializer.toJson<int?>(groupSize),
      'appointmentId': serializer.toJson<String?>(appointmentId),
    };
  }

  Ticket copyWith({
    String? id,
    Value<String?> customerId = const Value.absent(),
    int? employeeId,
    int? ticketNumber,
    String? customerName,
    List<Map<String, dynamic>>? services,
    Value<int?> priority = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> status = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    Value<String?> updatedAt = const Value.absent(),
    String? businessDate,
    Value<String?> checkInTime = const Value.absent(),
    Value<int?> assignedTechnicianId = const Value.absent(),
    Value<double?> totalAmount = const Value.absent(),
    Value<String?> paymentStatus = const Value.absent(),
    Value<int?> isGroupService = const Value.absent(),
    Value<int?> groupSize = const Value.absent(),
    Value<String?> appointmentId = const Value.absent(),
  }) => Ticket(
    id: id ?? this.id,
    customerId: customerId.present ? customerId.value : this.customerId,
    employeeId: employeeId ?? this.employeeId,
    ticketNumber: ticketNumber ?? this.ticketNumber,
    customerName: customerName ?? this.customerName,
    services: services ?? this.services,
    priority: priority.present ? priority.value : this.priority,
    notes: notes.present ? notes.value : this.notes,
    status: status.present ? status.value : this.status,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    businessDate: businessDate ?? this.businessDate,
    checkInTime: checkInTime.present ? checkInTime.value : this.checkInTime,
    assignedTechnicianId: assignedTechnicianId.present
        ? assignedTechnicianId.value
        : this.assignedTechnicianId,
    totalAmount: totalAmount.present ? totalAmount.value : this.totalAmount,
    paymentStatus: paymentStatus.present
        ? paymentStatus.value
        : this.paymentStatus,
    isGroupService: isGroupService.present
        ? isGroupService.value
        : this.isGroupService,
    groupSize: groupSize.present ? groupSize.value : this.groupSize,
    appointmentId: appointmentId.present
        ? appointmentId.value
        : this.appointmentId,
  );
  Ticket copyWithCompanion(TicketsCompanion data) {
    return Ticket(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      ticketNumber: data.ticketNumber.present
          ? data.ticketNumber.value
          : this.ticketNumber,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      services: data.services.present ? data.services.value : this.services,
      priority: data.priority.present ? data.priority.value : this.priority,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      businessDate: data.businessDate.present
          ? data.businessDate.value
          : this.businessDate,
      checkInTime: data.checkInTime.present
          ? data.checkInTime.value
          : this.checkInTime,
      assignedTechnicianId: data.assignedTechnicianId.present
          ? data.assignedTechnicianId.value
          : this.assignedTechnicianId,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      isGroupService: data.isGroupService.present
          ? data.isGroupService.value
          : this.isGroupService,
      groupSize: data.groupSize.present ? data.groupSize.value : this.groupSize,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ticket(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('employeeId: $employeeId, ')
          ..write('ticketNumber: $ticketNumber, ')
          ..write('customerName: $customerName, ')
          ..write('services: $services, ')
          ..write('priority: $priority, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('businessDate: $businessDate, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('isGroupService: $isGroupService, ')
          ..write('groupSize: $groupSize, ')
          ..write('appointmentId: $appointmentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    employeeId,
    ticketNumber,
    customerName,
    services,
    priority,
    notes,
    status,
    createdAt,
    updatedAt,
    businessDate,
    checkInTime,
    assignedTechnicianId,
    totalAmount,
    paymentStatus,
    isGroupService,
    groupSize,
    appointmentId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ticket &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.employeeId == this.employeeId &&
          other.ticketNumber == this.ticketNumber &&
          other.customerName == this.customerName &&
          other.services == this.services &&
          other.priority == this.priority &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.businessDate == this.businessDate &&
          other.checkInTime == this.checkInTime &&
          other.assignedTechnicianId == this.assignedTechnicianId &&
          other.totalAmount == this.totalAmount &&
          other.paymentStatus == this.paymentStatus &&
          other.isGroupService == this.isGroupService &&
          other.groupSize == this.groupSize &&
          other.appointmentId == this.appointmentId);
}

class TicketsCompanion extends UpdateCompanion<Ticket> {
  final Value<String> id;
  final Value<String?> customerId;
  final Value<int> employeeId;
  final Value<int> ticketNumber;
  final Value<String> customerName;
  final Value<List<Map<String, dynamic>>> services;
  final Value<int?> priority;
  final Value<String?> notes;
  final Value<String?> status;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<String> businessDate;
  final Value<String?> checkInTime;
  final Value<int?> assignedTechnicianId;
  final Value<double?> totalAmount;
  final Value<String?> paymentStatus;
  final Value<int?> isGroupService;
  final Value<int?> groupSize;
  final Value<String?> appointmentId;
  final Value<int> rowid;
  const TicketsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.ticketNumber = const Value.absent(),
    this.customerName = const Value.absent(),
    this.services = const Value.absent(),
    this.priority = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.businessDate = const Value.absent(),
    this.checkInTime = const Value.absent(),
    this.assignedTechnicianId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.isGroupService = const Value.absent(),
    this.groupSize = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TicketsCompanion.insert({
    required String id,
    this.customerId = const Value.absent(),
    required int employeeId,
    required int ticketNumber,
    required String customerName,
    required List<Map<String, dynamic>> services,
    this.priority = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required String businessDate,
    this.checkInTime = const Value.absent(),
    this.assignedTechnicianId = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.isGroupService = const Value.absent(),
    this.groupSize = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employeeId = Value(employeeId),
       ticketNumber = Value(ticketNumber),
       customerName = Value(customerName),
       services = Value(services),
       businessDate = Value(businessDate);
  static Insertable<Ticket> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<int>? employeeId,
    Expression<int>? ticketNumber,
    Expression<String>? customerName,
    Expression<String>? services,
    Expression<int>? priority,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? businessDate,
    Expression<String>? checkInTime,
    Expression<int>? assignedTechnicianId,
    Expression<double>? totalAmount,
    Expression<String>? paymentStatus,
    Expression<int>? isGroupService,
    Expression<int>? groupSize,
    Expression<String>? appointmentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (employeeId != null) 'employee_id': employeeId,
      if (ticketNumber != null) 'ticket_number': ticketNumber,
      if (customerName != null) 'customer_name': customerName,
      if (services != null) 'services': services,
      if (priority != null) 'priority': priority,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (businessDate != null) 'business_date': businessDate,
      if (checkInTime != null) 'check_in_time': checkInTime,
      if (assignedTechnicianId != null)
        'assigned_technician_id': assignedTechnicianId,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (isGroupService != null) 'is_group_service': isGroupService,
      if (groupSize != null) 'group_size': groupSize,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TicketsCompanion copyWith({
    Value<String>? id,
    Value<String?>? customerId,
    Value<int>? employeeId,
    Value<int>? ticketNumber,
    Value<String>? customerName,
    Value<List<Map<String, dynamic>>>? services,
    Value<int?>? priority,
    Value<String?>? notes,
    Value<String?>? status,
    Value<String?>? createdAt,
    Value<String?>? updatedAt,
    Value<String>? businessDate,
    Value<String?>? checkInTime,
    Value<int?>? assignedTechnicianId,
    Value<double?>? totalAmount,
    Value<String?>? paymentStatus,
    Value<int?>? isGroupService,
    Value<int?>? groupSize,
    Value<String?>? appointmentId,
    Value<int>? rowid,
  }) {
    return TicketsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      employeeId: employeeId ?? this.employeeId,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      customerName: customerName ?? this.customerName,
      services: services ?? this.services,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      businessDate: businessDate ?? this.businessDate,
      checkInTime: checkInTime ?? this.checkInTime,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      isGroupService: isGroupService ?? this.isGroupService,
      groupSize: groupSize ?? this.groupSize,
      appointmentId: appointmentId ?? this.appointmentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (ticketNumber.present) {
      map['ticket_number'] = Variable<int>(ticketNumber.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (services.present) {
      map['services'] = Variable<String>(
        $TicketsTable.$converterservices.toSql(services.value),
      );
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (businessDate.present) {
      map['business_date'] = Variable<String>(businessDate.value);
    }
    if (checkInTime.present) {
      map['check_in_time'] = Variable<String>(checkInTime.value);
    }
    if (assignedTechnicianId.present) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (isGroupService.present) {
      map['is_group_service'] = Variable<int>(isGroupService.value);
    }
    if (groupSize.present) {
      map['group_size'] = Variable<int>(groupSize.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('employeeId: $employeeId, ')
          ..write('ticketNumber: $ticketNumber, ')
          ..write('customerName: $customerName, ')
          ..write('services: $services, ')
          ..write('priority: $priority, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('businessDate: $businessDate, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('isGroupService: $isGroupService, ')
          ..write('groupSize: $groupSize, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServicesTable extends Services with TableInfo<$ServicesTable, Service> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _basePriceMeta = const VerificationMeta(
    'basePrice',
  );
  @override
  late final GeneratedColumn<double> basePrice = GeneratedColumn<double>(
    'base_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    categoryId,
    durationMinutes,
    basePrice,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'services';
  @override
  VerificationContext validateIntegrity(
    Insertable<Service> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('base_price')) {
      context.handle(
        _basePriceMeta,
        basePrice.isAcceptableOrUnknown(data['base_price']!, _basePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_basePriceMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Service map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Service(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      basePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}base_price'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ServicesTable createAlias(String alias) {
    return $ServicesTable(attachedDatabase, alias);
  }
}

class Service extends DataClass implements Insertable<Service> {
  final int id;
  final String name;
  final String? description;
  final int? categoryId;
  final int durationMinutes;
  final double basePrice;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;
  const Service({
    required this.id,
    required this.name,
    this.description,
    this.categoryId,
    required this.durationMinutes,
    required this.basePrice,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['base_price'] = Variable<double>(basePrice);
    if (!nullToAbsent || isActive != null) {
      map['is_active'] = Variable<int>(isActive);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      durationMinutes: Value(durationMinutes),
      basePrice: Value(basePrice),
      isActive: isActive == null && nullToAbsent
          ? const Value.absent()
          : Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Service.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Service(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      basePrice: serializer.fromJson<double>(json['basePrice']),
      isActive: serializer.fromJson<int?>(json['isActive']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'categoryId': serializer.toJson<int?>(categoryId),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'basePrice': serializer.toJson<double>(basePrice),
      'isActive': serializer.toJson<int?>(isActive),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  Service copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    int? durationMinutes,
    double? basePrice,
    Value<int?> isActive = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    Value<String?> updatedAt = const Value.absent(),
  }) => Service(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    basePrice: basePrice ?? this.basePrice,
    isActive: isActive.present ? isActive.value : this.isActive,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Service copyWithCompanion(ServicesCompanion data) {
    return Service(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      basePrice: data.basePrice.present ? data.basePrice.value : this.basePrice,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Service(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('basePrice: $basePrice, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    categoryId,
    durationMinutes,
    basePrice,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Service &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.categoryId == this.categoryId &&
          other.durationMinutes == this.durationMinutes &&
          other.basePrice == this.basePrice &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int?> categoryId;
  final Value<int> durationMinutes;
  final Value<double> basePrice;
  final Value<int?> isActive;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.basePrice = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    required int durationMinutes,
    required double basePrice,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       durationMinutes = Value(durationMinutes),
       basePrice = Value(basePrice);
  static Insertable<Service> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<int>? durationMinutes,
    Expression<double>? basePrice,
    Expression<int>? isActive,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (basePrice != null) 'base_price': basePrice,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ServicesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int?>? categoryId,
    Value<int>? durationMinutes,
    Value<double>? basePrice,
    Value<int?>? isActive,
    Value<String?>? createdAt,
    Value<String?>? updatedAt,
  }) {
    return ServicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      basePrice: basePrice ?? this.basePrice,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (basePrice.present) {
      map['base_price'] = Variable<double>(basePrice.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('categoryId: $categoryId, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('basePrice: $basePrice, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $InvoicesTable extends Invoices with TableInfo<$InvoicesTable, Invoice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ticketIdsMeta = const VerificationMeta(
    'ticketIds',
  );
  @override
  late final GeneratedColumn<String> ticketIds = GeneratedColumn<String>(
    'ticket_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
    'tax_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipAmountMeta = const VerificationMeta(
    'tipAmount',
  );
  @override
  late final GeneratedColumn<double> tipAmount = GeneratedColumn<double>(
    'tip_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
    'discount_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountTypeMeta = const VerificationMeta(
    'discountType',
  );
  @override
  late final GeneratedColumn<String> discountType = GeneratedColumn<String>(
    'discount_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountCodeMeta = const VerificationMeta(
    'discountCode',
  );
  @override
  late final GeneratedColumn<String> discountCode = GeneratedColumn<String>(
    'discount_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountReasonMeta = const VerificationMeta(
    'discountReason',
  );
  @override
  late final GeneratedColumn<String> discountReason = GeneratedColumn<String>(
    'discount_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardTypeMeta = const VerificationMeta(
    'cardType',
  );
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
    'card_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastFourDigitsMeta = const VerificationMeta(
    'lastFourDigits',
  );
  @override
  late final GeneratedColumn<String> lastFourDigits = GeneratedColumn<String>(
    'last_four_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorizationCodeMeta = const VerificationMeta(
    'authorizationCode',
  );
  @override
  late final GeneratedColumn<String> authorizationCode =
      GeneratedColumn<String>(
        'authorization_code',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _processedAtMeta = const VerificationMeta(
    'processedAt',
  );
  @override
  late final GeneratedColumn<String> processedAt = GeneratedColumn<String>(
    'processed_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processedByMeta = const VerificationMeta(
    'processedBy',
  );
  @override
  late final GeneratedColumn<String> processedBy = GeneratedColumn<String>(
    'processed_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNumber,
    ticketIds,
    customerName,
    subtotal,
    taxAmount,
    tipAmount,
    discountAmount,
    totalAmount,
    paymentMethod,
    discountType,
    discountCode,
    discountReason,
    cardType,
    lastFourDigits,
    transactionId,
    authorizationCode,
    processedAt,
    processedBy,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Invoice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('ticket_ids')) {
      context.handle(
        _ticketIdsMeta,
        ticketIds.isAcceptableOrUnknown(data['ticket_ids']!, _ticketIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_ticketIdsMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_taxAmountMeta);
    }
    if (data.containsKey('tip_amount')) {
      context.handle(
        _tipAmountMeta,
        tipAmount.isAcceptableOrUnknown(data['tip_amount']!, _tipAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_tipAmountMeta);
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountAmountMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('discount_type')) {
      context.handle(
        _discountTypeMeta,
        discountType.isAcceptableOrUnknown(
          data['discount_type']!,
          _discountTypeMeta,
        ),
      );
    }
    if (data.containsKey('discount_code')) {
      context.handle(
        _discountCodeMeta,
        discountCode.isAcceptableOrUnknown(
          data['discount_code']!,
          _discountCodeMeta,
        ),
      );
    }
    if (data.containsKey('discount_reason')) {
      context.handle(
        _discountReasonMeta,
        discountReason.isAcceptableOrUnknown(
          data['discount_reason']!,
          _discountReasonMeta,
        ),
      );
    }
    if (data.containsKey('card_type')) {
      context.handle(
        _cardTypeMeta,
        cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta),
      );
    }
    if (data.containsKey('last_four_digits')) {
      context.handle(
        _lastFourDigitsMeta,
        lastFourDigits.isAcceptableOrUnknown(
          data['last_four_digits']!,
          _lastFourDigitsMeta,
        ),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('authorization_code')) {
      context.handle(
        _authorizationCodeMeta,
        authorizationCode.isAcceptableOrUnknown(
          data['authorization_code']!,
          _authorizationCodeMeta,
        ),
      );
    }
    if (data.containsKey('processed_at')) {
      context.handle(
        _processedAtMeta,
        processedAt.isAcceptableOrUnknown(
          data['processed_at']!,
          _processedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processedAtMeta);
    }
    if (data.containsKey('processed_by')) {
      context.handle(
        _processedByMeta,
        processedBy.isAcceptableOrUnknown(
          data['processed_by']!,
          _processedByMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processedByMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Invoice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Invoice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      ticketIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ticket_ids'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_amount'],
      )!,
      tipAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tip_amount'],
      )!,
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_amount'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      discountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_type'],
      ),
      discountCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_code'],
      ),
      discountReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_reason'],
      ),
      cardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_type'],
      ),
      lastFourDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_four_digits'],
      ),
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
      authorizationCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authorization_code'],
      ),
      processedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processed_at'],
      )!,
      processedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processed_by'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $InvoicesTable createAlias(String alias) {
    return $InvoicesTable(attachedDatabase, alias);
  }
}

class Invoice extends DataClass implements Insertable<Invoice> {
  final String id;
  final String invoiceNumber;
  final String ticketIds;
  final String? customerName;
  final double subtotal;
  final double taxAmount;
  final double tipAmount;
  final double discountAmount;
  final double totalAmount;
  final String paymentMethod;
  final String? discountType;
  final String? discountCode;
  final String? discountReason;
  final String? cardType;
  final String? lastFourDigits;
  final String? transactionId;
  final String? authorizationCode;
  final String processedAt;
  final String processedBy;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  const Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.ticketIds,
    this.customerName,
    required this.subtotal,
    required this.taxAmount,
    required this.tipAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.paymentMethod,
    this.discountType,
    this.discountCode,
    this.discountReason,
    this.cardType,
    this.lastFourDigits,
    this.transactionId,
    this.authorizationCode,
    required this.processedAt,
    required this.processedBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['ticket_ids'] = Variable<String>(ticketIds);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['subtotal'] = Variable<double>(subtotal);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['tip_amount'] = Variable<double>(tipAmount);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['total_amount'] = Variable<double>(totalAmount);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || discountType != null) {
      map['discount_type'] = Variable<String>(discountType);
    }
    if (!nullToAbsent || discountCode != null) {
      map['discount_code'] = Variable<String>(discountCode);
    }
    if (!nullToAbsent || discountReason != null) {
      map['discount_reason'] = Variable<String>(discountReason);
    }
    if (!nullToAbsent || cardType != null) {
      map['card_type'] = Variable<String>(cardType);
    }
    if (!nullToAbsent || lastFourDigits != null) {
      map['last_four_digits'] = Variable<String>(lastFourDigits);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    if (!nullToAbsent || authorizationCode != null) {
      map['authorization_code'] = Variable<String>(authorizationCode);
    }
    map['processed_at'] = Variable<String>(processedAt);
    map['processed_by'] = Variable<String>(processedBy);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      ticketIds: Value(ticketIds),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      subtotal: Value(subtotal),
      taxAmount: Value(taxAmount),
      tipAmount: Value(tipAmount),
      discountAmount: Value(discountAmount),
      totalAmount: Value(totalAmount),
      paymentMethod: Value(paymentMethod),
      discountType: discountType == null && nullToAbsent
          ? const Value.absent()
          : Value(discountType),
      discountCode: discountCode == null && nullToAbsent
          ? const Value.absent()
          : Value(discountCode),
      discountReason: discountReason == null && nullToAbsent
          ? const Value.absent()
          : Value(discountReason),
      cardType: cardType == null && nullToAbsent
          ? const Value.absent()
          : Value(cardType),
      lastFourDigits: lastFourDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFourDigits),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      authorizationCode: authorizationCode == null && nullToAbsent
          ? const Value.absent()
          : Value(authorizationCode),
      processedAt: Value(processedAt),
      processedBy: Value(processedBy),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Invoice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Invoice(
      id: serializer.fromJson<String>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      ticketIds: serializer.fromJson<String>(json['ticketIds']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      tipAmount: serializer.fromJson<double>(json['tipAmount']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      discountType: serializer.fromJson<String?>(json['discountType']),
      discountCode: serializer.fromJson<String?>(json['discountCode']),
      discountReason: serializer.fromJson<String?>(json['discountReason']),
      cardType: serializer.fromJson<String?>(json['cardType']),
      lastFourDigits: serializer.fromJson<String?>(json['lastFourDigits']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      authorizationCode: serializer.fromJson<String?>(
        json['authorizationCode'],
      ),
      processedAt: serializer.fromJson<String>(json['processedAt']),
      processedBy: serializer.fromJson<String>(json['processedBy']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'ticketIds': serializer.toJson<String>(ticketIds),
      'customerName': serializer.toJson<String?>(customerName),
      'subtotal': serializer.toJson<double>(subtotal),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'tipAmount': serializer.toJson<double>(tipAmount),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'discountType': serializer.toJson<String?>(discountType),
      'discountCode': serializer.toJson<String?>(discountCode),
      'discountReason': serializer.toJson<String?>(discountReason),
      'cardType': serializer.toJson<String?>(cardType),
      'lastFourDigits': serializer.toJson<String?>(lastFourDigits),
      'transactionId': serializer.toJson<String?>(transactionId),
      'authorizationCode': serializer.toJson<String?>(authorizationCode),
      'processedAt': serializer.toJson<String>(processedAt),
      'processedBy': serializer.toJson<String>(processedBy),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    String? ticketIds,
    Value<String?> customerName = const Value.absent(),
    double? subtotal,
    double? taxAmount,
    double? tipAmount,
    double? discountAmount,
    double? totalAmount,
    String? paymentMethod,
    Value<String?> discountType = const Value.absent(),
    Value<String?> discountCode = const Value.absent(),
    Value<String?> discountReason = const Value.absent(),
    Value<String?> cardType = const Value.absent(),
    Value<String?> lastFourDigits = const Value.absent(),
    Value<String?> transactionId = const Value.absent(),
    Value<String?> authorizationCode = const Value.absent(),
    String? processedAt,
    String? processedBy,
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => Invoice(
    id: id ?? this.id,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    ticketIds: ticketIds ?? this.ticketIds,
    customerName: customerName.present ? customerName.value : this.customerName,
    subtotal: subtotal ?? this.subtotal,
    taxAmount: taxAmount ?? this.taxAmount,
    tipAmount: tipAmount ?? this.tipAmount,
    discountAmount: discountAmount ?? this.discountAmount,
    totalAmount: totalAmount ?? this.totalAmount,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    discountType: discountType.present ? discountType.value : this.discountType,
    discountCode: discountCode.present ? discountCode.value : this.discountCode,
    discountReason: discountReason.present
        ? discountReason.value
        : this.discountReason,
    cardType: cardType.present ? cardType.value : this.cardType,
    lastFourDigits: lastFourDigits.present
        ? lastFourDigits.value
        : this.lastFourDigits,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    authorizationCode: authorizationCode.present
        ? authorizationCode.value
        : this.authorizationCode,
    processedAt: processedAt ?? this.processedAt,
    processedBy: processedBy ?? this.processedBy,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Invoice copyWithCompanion(InvoicesCompanion data) {
    return Invoice(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      ticketIds: data.ticketIds.present ? data.ticketIds.value : this.ticketIds,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      tipAmount: data.tipAmount.present ? data.tipAmount.value : this.tipAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      discountCode: data.discountCode.present
          ? data.discountCode.value
          : this.discountCode,
      discountReason: data.discountReason.present
          ? data.discountReason.value
          : this.discountReason,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      lastFourDigits: data.lastFourDigits.present
          ? data.lastFourDigits.value
          : this.lastFourDigits,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      authorizationCode: data.authorizationCode.present
          ? data.authorizationCode.value
          : this.authorizationCode,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
      processedBy: data.processedBy.present
          ? data.processedBy.value
          : this.processedBy,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Invoice(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('ticketIds: $ticketIds, ')
          ..write('customerName: $customerName, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('tipAmount: $tipAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('discountType: $discountType, ')
          ..write('discountCode: $discountCode, ')
          ..write('discountReason: $discountReason, ')
          ..write('cardType: $cardType, ')
          ..write('lastFourDigits: $lastFourDigits, ')
          ..write('transactionId: $transactionId, ')
          ..write('authorizationCode: $authorizationCode, ')
          ..write('processedAt: $processedAt, ')
          ..write('processedBy: $processedBy, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    invoiceNumber,
    ticketIds,
    customerName,
    subtotal,
    taxAmount,
    tipAmount,
    discountAmount,
    totalAmount,
    paymentMethod,
    discountType,
    discountCode,
    discountReason,
    cardType,
    lastFourDigits,
    transactionId,
    authorizationCode,
    processedAt,
    processedBy,
    notes,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Invoice &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.ticketIds == this.ticketIds &&
          other.customerName == this.customerName &&
          other.subtotal == this.subtotal &&
          other.taxAmount == this.taxAmount &&
          other.tipAmount == this.tipAmount &&
          other.discountAmount == this.discountAmount &&
          other.totalAmount == this.totalAmount &&
          other.paymentMethod == this.paymentMethod &&
          other.discountType == this.discountType &&
          other.discountCode == this.discountCode &&
          other.discountReason == this.discountReason &&
          other.cardType == this.cardType &&
          other.lastFourDigits == this.lastFourDigits &&
          other.transactionId == this.transactionId &&
          other.authorizationCode == this.authorizationCode &&
          other.processedAt == this.processedAt &&
          other.processedBy == this.processedBy &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class InvoicesCompanion extends UpdateCompanion<Invoice> {
  final Value<String> id;
  final Value<String> invoiceNumber;
  final Value<String> ticketIds;
  final Value<String?> customerName;
  final Value<double> subtotal;
  final Value<double> taxAmount;
  final Value<double> tipAmount;
  final Value<double> discountAmount;
  final Value<double> totalAmount;
  final Value<String> paymentMethod;
  final Value<String?> discountType;
  final Value<String?> discountCode;
  final Value<String?> discountReason;
  final Value<String?> cardType;
  final Value<String?> lastFourDigits;
  final Value<String?> transactionId;
  final Value<String?> authorizationCode;
  final Value<String> processedAt;
  final Value<String> processedBy;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.ticketIds = const Value.absent(),
    this.customerName = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.tipAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountCode = const Value.absent(),
    this.discountReason = const Value.absent(),
    this.cardType = const Value.absent(),
    this.lastFourDigits = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.authorizationCode = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.processedBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoicesCompanion.insert({
    required String id,
    required String invoiceNumber,
    required String ticketIds,
    this.customerName = const Value.absent(),
    required double subtotal,
    required double taxAmount,
    required double tipAmount,
    required double discountAmount,
    required double totalAmount,
    required String paymentMethod,
    this.discountType = const Value.absent(),
    this.discountCode = const Value.absent(),
    this.discountReason = const Value.absent(),
    this.cardType = const Value.absent(),
    this.lastFourDigits = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.authorizationCode = const Value.absent(),
    required String processedAt,
    required String processedBy,
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       invoiceNumber = Value(invoiceNumber),
       ticketIds = Value(ticketIds),
       subtotal = Value(subtotal),
       taxAmount = Value(taxAmount),
       tipAmount = Value(tipAmount),
       discountAmount = Value(discountAmount),
       totalAmount = Value(totalAmount),
       paymentMethod = Value(paymentMethod),
       processedAt = Value(processedAt),
       processedBy = Value(processedBy),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Invoice> custom({
    Expression<String>? id,
    Expression<String>? invoiceNumber,
    Expression<String>? ticketIds,
    Expression<String>? customerName,
    Expression<double>? subtotal,
    Expression<double>? taxAmount,
    Expression<double>? tipAmount,
    Expression<double>? discountAmount,
    Expression<double>? totalAmount,
    Expression<String>? paymentMethod,
    Expression<String>? discountType,
    Expression<String>? discountCode,
    Expression<String>? discountReason,
    Expression<String>? cardType,
    Expression<String>? lastFourDigits,
    Expression<String>? transactionId,
    Expression<String>? authorizationCode,
    Expression<String>? processedAt,
    Expression<String>? processedBy,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (ticketIds != null) 'ticket_ids': ticketIds,
      if (customerName != null) 'customer_name': customerName,
      if (subtotal != null) 'subtotal': subtotal,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (tipAmount != null) 'tip_amount': tipAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (discountType != null) 'discount_type': discountType,
      if (discountCode != null) 'discount_code': discountCode,
      if (discountReason != null) 'discount_reason': discountReason,
      if (cardType != null) 'card_type': cardType,
      if (lastFourDigits != null) 'last_four_digits': lastFourDigits,
      if (transactionId != null) 'transaction_id': transactionId,
      if (authorizationCode != null) 'authorization_code': authorizationCode,
      if (processedAt != null) 'processed_at': processedAt,
      if (processedBy != null) 'processed_by': processedBy,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoicesCompanion copyWith({
    Value<String>? id,
    Value<String>? invoiceNumber,
    Value<String>? ticketIds,
    Value<String?>? customerName,
    Value<double>? subtotal,
    Value<double>? taxAmount,
    Value<double>? tipAmount,
    Value<double>? discountAmount,
    Value<double>? totalAmount,
    Value<String>? paymentMethod,
    Value<String?>? discountType,
    Value<String?>? discountCode,
    Value<String?>? discountReason,
    Value<String?>? cardType,
    Value<String?>? lastFourDigits,
    Value<String?>? transactionId,
    Value<String?>? authorizationCode,
    Value<String>? processedAt,
    Value<String>? processedBy,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      ticketIds: ticketIds ?? this.ticketIds,
      customerName: customerName ?? this.customerName,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      tipAmount: tipAmount ?? this.tipAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      discountType: discountType ?? this.discountType,
      discountCode: discountCode ?? this.discountCode,
      discountReason: discountReason ?? this.discountReason,
      cardType: cardType ?? this.cardType,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      transactionId: transactionId ?? this.transactionId,
      authorizationCode: authorizationCode ?? this.authorizationCode,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (ticketIds.present) {
      map['ticket_ids'] = Variable<String>(ticketIds.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (tipAmount.present) {
      map['tip_amount'] = Variable<double>(tipAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(discountType.value);
    }
    if (discountCode.present) {
      map['discount_code'] = Variable<String>(discountCode.value);
    }
    if (discountReason.present) {
      map['discount_reason'] = Variable<String>(discountReason.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (lastFourDigits.present) {
      map['last_four_digits'] = Variable<String>(lastFourDigits.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (authorizationCode.present) {
      map['authorization_code'] = Variable<String>(authorizationCode.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<String>(processedAt.value);
    }
    if (processedBy.present) {
      map['processed_by'] = Variable<String>(processedBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoicesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('ticketIds: $ticketIds, ')
          ..write('customerName: $customerName, ')
          ..write('subtotal: $subtotal, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('tipAmount: $tipAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('discountType: $discountType, ')
          ..write('discountCode: $discountCode, ')
          ..write('discountReason: $discountReason, ')
          ..write('cardType: $cardType, ')
          ..write('lastFourDigits: $lastFourDigits, ')
          ..write('transactionId: $transactionId, ')
          ..write('authorizationCode: $authorizationCode, ')
          ..write('processedAt: $processedAt, ')
          ..write('processedBy: $processedBy, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ticketIdMeta = const VerificationMeta(
    'ticketId',
  );
  @override
  late final GeneratedColumn<String> ticketId = GeneratedColumn<String>(
    'ticket_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipAmountMeta = const VerificationMeta(
    'tipAmount',
  );
  @override
  late final GeneratedColumn<double> tipAmount = GeneratedColumn<double>(
    'tip_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxAmountMeta = const VerificationMeta(
    'taxAmount',
  );
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
    'tax_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountAmountMeta = const VerificationMeta(
    'discountAmount',
  );
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
    'discount_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountTypeMeta = const VerificationMeta(
    'discountType',
  );
  @override
  late final GeneratedColumn<String> discountType = GeneratedColumn<String>(
    'discount_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountCodeMeta = const VerificationMeta(
    'discountCode',
  );
  @override
  late final GeneratedColumn<String> discountCode = GeneratedColumn<String>(
    'discount_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountReasonMeta = const VerificationMeta(
    'discountReason',
  );
  @override
  late final GeneratedColumn<String> discountReason = GeneratedColumn<String>(
    'discount_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cardTypeMeta = const VerificationMeta(
    'cardType',
  );
  @override
  late final GeneratedColumn<String> cardType = GeneratedColumn<String>(
    'card_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastFourDigitsMeta = const VerificationMeta(
    'lastFourDigits',
  );
  @override
  late final GeneratedColumn<String> lastFourDigits = GeneratedColumn<String>(
    'last_four_digits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorizationCodeMeta = const VerificationMeta(
    'authorizationCode',
  );
  @override
  late final GeneratedColumn<String> authorizationCode =
      GeneratedColumn<String>(
        'authorization_code',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _processedAtMeta = const VerificationMeta(
    'processedAt',
  );
  @override
  late final GeneratedColumn<String> processedAt = GeneratedColumn<String>(
    'processed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _processedByMeta = const VerificationMeta(
    'processedBy',
  );
  @override
  late final GeneratedColumn<String> processedBy = GeneratedColumn<String>(
    'processed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ticketId,
    invoiceId,
    paymentMethod,
    amount,
    tipAmount,
    taxAmount,
    discountAmount,
    totalAmount,
    discountType,
    discountCode,
    discountReason,
    cardType,
    lastFourDigits,
    transactionId,
    authorizationCode,
    processedAt,
    processedBy,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ticket_id')) {
      context.handle(
        _ticketIdMeta,
        ticketId.isAcceptableOrUnknown(data['ticket_id']!, _ticketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ticketIdMeta);
    }
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('tip_amount')) {
      context.handle(
        _tipAmountMeta,
        tipAmount.isAcceptableOrUnknown(data['tip_amount']!, _tipAmountMeta),
      );
    }
    if (data.containsKey('tax_amount')) {
      context.handle(
        _taxAmountMeta,
        taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta),
      );
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
        _discountAmountMeta,
        discountAmount.isAcceptableOrUnknown(
          data['discount_amount']!,
          _discountAmountMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    }
    if (data.containsKey('discount_type')) {
      context.handle(
        _discountTypeMeta,
        discountType.isAcceptableOrUnknown(
          data['discount_type']!,
          _discountTypeMeta,
        ),
      );
    }
    if (data.containsKey('discount_code')) {
      context.handle(
        _discountCodeMeta,
        discountCode.isAcceptableOrUnknown(
          data['discount_code']!,
          _discountCodeMeta,
        ),
      );
    }
    if (data.containsKey('discount_reason')) {
      context.handle(
        _discountReasonMeta,
        discountReason.isAcceptableOrUnknown(
          data['discount_reason']!,
          _discountReasonMeta,
        ),
      );
    }
    if (data.containsKey('card_type')) {
      context.handle(
        _cardTypeMeta,
        cardType.isAcceptableOrUnknown(data['card_type']!, _cardTypeMeta),
      );
    }
    if (data.containsKey('last_four_digits')) {
      context.handle(
        _lastFourDigitsMeta,
        lastFourDigits.isAcceptableOrUnknown(
          data['last_four_digits']!,
          _lastFourDigitsMeta,
        ),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    if (data.containsKey('authorization_code')) {
      context.handle(
        _authorizationCodeMeta,
        authorizationCode.isAcceptableOrUnknown(
          data['authorization_code']!,
          _authorizationCodeMeta,
        ),
      );
    }
    if (data.containsKey('processed_at')) {
      context.handle(
        _processedAtMeta,
        processedAt.isAcceptableOrUnknown(
          data['processed_at']!,
          _processedAtMeta,
        ),
      );
    }
    if (data.containsKey('processed_by')) {
      context.handle(
        _processedByMeta,
        processedBy.isAcceptableOrUnknown(
          data['processed_by']!,
          _processedByMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ticketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ticket_id'],
      )!,
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      ),
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      tipAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tip_amount'],
      ),
      taxAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax_amount'],
      ),
      discountAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount_amount'],
      ),
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      ),
      discountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_type'],
      ),
      discountCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_code'],
      ),
      discountReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}discount_reason'],
      ),
      cardType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_type'],
      ),
      lastFourDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_four_digits'],
      ),
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
      authorizationCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authorization_code'],
      ),
      processedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processed_at'],
      ),
      processedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}processed_by'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String id;
  final String ticketId;
  final String? invoiceId;
  final String paymentMethod;
  final double amount;
  final double? tipAmount;
  final double? taxAmount;
  final double? discountAmount;
  final double? totalAmount;
  final String? discountType;
  final String? discountCode;
  final String? discountReason;
  final String? cardType;
  final String? lastFourDigits;
  final String? transactionId;
  final String? authorizationCode;
  final String? processedAt;
  final String? processedBy;
  final String? notes;
  final String? createdAt;
  final String? updatedAt;
  const Payment({
    required this.id,
    required this.ticketId,
    this.invoiceId,
    required this.paymentMethod,
    required this.amount,
    this.tipAmount,
    this.taxAmount,
    this.discountAmount,
    this.totalAmount,
    this.discountType,
    this.discountCode,
    this.discountReason,
    this.cardType,
    this.lastFourDigits,
    this.transactionId,
    this.authorizationCode,
    this.processedAt,
    this.processedBy,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ticket_id'] = Variable<String>(ticketId);
    if (!nullToAbsent || invoiceId != null) {
      map['invoice_id'] = Variable<String>(invoiceId);
    }
    map['payment_method'] = Variable<String>(paymentMethod);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || tipAmount != null) {
      map['tip_amount'] = Variable<double>(tipAmount);
    }
    if (!nullToAbsent || taxAmount != null) {
      map['tax_amount'] = Variable<double>(taxAmount);
    }
    if (!nullToAbsent || discountAmount != null) {
      map['discount_amount'] = Variable<double>(discountAmount);
    }
    if (!nullToAbsent || totalAmount != null) {
      map['total_amount'] = Variable<double>(totalAmount);
    }
    if (!nullToAbsent || discountType != null) {
      map['discount_type'] = Variable<String>(discountType);
    }
    if (!nullToAbsent || discountCode != null) {
      map['discount_code'] = Variable<String>(discountCode);
    }
    if (!nullToAbsent || discountReason != null) {
      map['discount_reason'] = Variable<String>(discountReason);
    }
    if (!nullToAbsent || cardType != null) {
      map['card_type'] = Variable<String>(cardType);
    }
    if (!nullToAbsent || lastFourDigits != null) {
      map['last_four_digits'] = Variable<String>(lastFourDigits);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    if (!nullToAbsent || authorizationCode != null) {
      map['authorization_code'] = Variable<String>(authorizationCode);
    }
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<String>(processedAt);
    }
    if (!nullToAbsent || processedBy != null) {
      map['processed_by'] = Variable<String>(processedBy);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      ticketId: Value(ticketId),
      invoiceId: invoiceId == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceId),
      paymentMethod: Value(paymentMethod),
      amount: Value(amount),
      tipAmount: tipAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(tipAmount),
      taxAmount: taxAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(taxAmount),
      discountAmount: discountAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(discountAmount),
      totalAmount: totalAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmount),
      discountType: discountType == null && nullToAbsent
          ? const Value.absent()
          : Value(discountType),
      discountCode: discountCode == null && nullToAbsent
          ? const Value.absent()
          : Value(discountCode),
      discountReason: discountReason == null && nullToAbsent
          ? const Value.absent()
          : Value(discountReason),
      cardType: cardType == null && nullToAbsent
          ? const Value.absent()
          : Value(cardType),
      lastFourDigits: lastFourDigits == null && nullToAbsent
          ? const Value.absent()
          : Value(lastFourDigits),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
      authorizationCode: authorizationCode == null && nullToAbsent
          ? const Value.absent()
          : Value(authorizationCode),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
      processedBy: processedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(processedBy),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Payment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      id: serializer.fromJson<String>(json['id']),
      ticketId: serializer.fromJson<String>(json['ticketId']),
      invoiceId: serializer.fromJson<String?>(json['invoiceId']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      amount: serializer.fromJson<double>(json['amount']),
      tipAmount: serializer.fromJson<double?>(json['tipAmount']),
      taxAmount: serializer.fromJson<double?>(json['taxAmount']),
      discountAmount: serializer.fromJson<double?>(json['discountAmount']),
      totalAmount: serializer.fromJson<double?>(json['totalAmount']),
      discountType: serializer.fromJson<String?>(json['discountType']),
      discountCode: serializer.fromJson<String?>(json['discountCode']),
      discountReason: serializer.fromJson<String?>(json['discountReason']),
      cardType: serializer.fromJson<String?>(json['cardType']),
      lastFourDigits: serializer.fromJson<String?>(json['lastFourDigits']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      authorizationCode: serializer.fromJson<String?>(
        json['authorizationCode'],
      ),
      processedAt: serializer.fromJson<String?>(json['processedAt']),
      processedBy: serializer.fromJson<String?>(json['processedBy']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ticketId': serializer.toJson<String>(ticketId),
      'invoiceId': serializer.toJson<String?>(invoiceId),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'amount': serializer.toJson<double>(amount),
      'tipAmount': serializer.toJson<double?>(tipAmount),
      'taxAmount': serializer.toJson<double?>(taxAmount),
      'discountAmount': serializer.toJson<double?>(discountAmount),
      'totalAmount': serializer.toJson<double?>(totalAmount),
      'discountType': serializer.toJson<String?>(discountType),
      'discountCode': serializer.toJson<String?>(discountCode),
      'discountReason': serializer.toJson<String?>(discountReason),
      'cardType': serializer.toJson<String?>(cardType),
      'lastFourDigits': serializer.toJson<String?>(lastFourDigits),
      'transactionId': serializer.toJson<String?>(transactionId),
      'authorizationCode': serializer.toJson<String?>(authorizationCode),
      'processedAt': serializer.toJson<String?>(processedAt),
      'processedBy': serializer.toJson<String?>(processedBy),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  Payment copyWith({
    String? id,
    String? ticketId,
    Value<String?> invoiceId = const Value.absent(),
    String? paymentMethod,
    double? amount,
    Value<double?> tipAmount = const Value.absent(),
    Value<double?> taxAmount = const Value.absent(),
    Value<double?> discountAmount = const Value.absent(),
    Value<double?> totalAmount = const Value.absent(),
    Value<String?> discountType = const Value.absent(),
    Value<String?> discountCode = const Value.absent(),
    Value<String?> discountReason = const Value.absent(),
    Value<String?> cardType = const Value.absent(),
    Value<String?> lastFourDigits = const Value.absent(),
    Value<String?> transactionId = const Value.absent(),
    Value<String?> authorizationCode = const Value.absent(),
    Value<String?> processedAt = const Value.absent(),
    Value<String?> processedBy = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    Value<String?> updatedAt = const Value.absent(),
  }) => Payment(
    id: id ?? this.id,
    ticketId: ticketId ?? this.ticketId,
    invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    amount: amount ?? this.amount,
    tipAmount: tipAmount.present ? tipAmount.value : this.tipAmount,
    taxAmount: taxAmount.present ? taxAmount.value : this.taxAmount,
    discountAmount: discountAmount.present
        ? discountAmount.value
        : this.discountAmount,
    totalAmount: totalAmount.present ? totalAmount.value : this.totalAmount,
    discountType: discountType.present ? discountType.value : this.discountType,
    discountCode: discountCode.present ? discountCode.value : this.discountCode,
    discountReason: discountReason.present
        ? discountReason.value
        : this.discountReason,
    cardType: cardType.present ? cardType.value : this.cardType,
    lastFourDigits: lastFourDigits.present
        ? lastFourDigits.value
        : this.lastFourDigits,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
    authorizationCode: authorizationCode.present
        ? authorizationCode.value
        : this.authorizationCode,
    processedAt: processedAt.present ? processedAt.value : this.processedAt,
    processedBy: processedBy.present ? processedBy.value : this.processedBy,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      ticketId: data.ticketId.present ? data.ticketId.value : this.ticketId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      amount: data.amount.present ? data.amount.value : this.amount,
      tipAmount: data.tipAmount.present ? data.tipAmount.value : this.tipAmount,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      discountCode: data.discountCode.present
          ? data.discountCode.value
          : this.discountCode,
      discountReason: data.discountReason.present
          ? data.discountReason.value
          : this.discountReason,
      cardType: data.cardType.present ? data.cardType.value : this.cardType,
      lastFourDigits: data.lastFourDigits.present
          ? data.lastFourDigits.value
          : this.lastFourDigits,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      authorizationCode: data.authorizationCode.present
          ? data.authorizationCode.value
          : this.authorizationCode,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
      processedBy: data.processedBy.present
          ? data.processedBy.value
          : this.processedBy,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amount: $amount, ')
          ..write('tipAmount: $tipAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discountType: $discountType, ')
          ..write('discountCode: $discountCode, ')
          ..write('discountReason: $discountReason, ')
          ..write('cardType: $cardType, ')
          ..write('lastFourDigits: $lastFourDigits, ')
          ..write('transactionId: $transactionId, ')
          ..write('authorizationCode: $authorizationCode, ')
          ..write('processedAt: $processedAt, ')
          ..write('processedBy: $processedBy, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    ticketId,
    invoiceId,
    paymentMethod,
    amount,
    tipAmount,
    taxAmount,
    discountAmount,
    totalAmount,
    discountType,
    discountCode,
    discountReason,
    cardType,
    lastFourDigits,
    transactionId,
    authorizationCode,
    processedAt,
    processedBy,
    notes,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.id == this.id &&
          other.ticketId == this.ticketId &&
          other.invoiceId == this.invoiceId &&
          other.paymentMethod == this.paymentMethod &&
          other.amount == this.amount &&
          other.tipAmount == this.tipAmount &&
          other.taxAmount == this.taxAmount &&
          other.discountAmount == this.discountAmount &&
          other.totalAmount == this.totalAmount &&
          other.discountType == this.discountType &&
          other.discountCode == this.discountCode &&
          other.discountReason == this.discountReason &&
          other.cardType == this.cardType &&
          other.lastFourDigits == this.lastFourDigits &&
          other.transactionId == this.transactionId &&
          other.authorizationCode == this.authorizationCode &&
          other.processedAt == this.processedAt &&
          other.processedBy == this.processedBy &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String> ticketId;
  final Value<String?> invoiceId;
  final Value<String> paymentMethod;
  final Value<double> amount;
  final Value<double?> tipAmount;
  final Value<double?> taxAmount;
  final Value<double?> discountAmount;
  final Value<double?> totalAmount;
  final Value<String?> discountType;
  final Value<String?> discountCode;
  final Value<String?> discountReason;
  final Value<String?> cardType;
  final Value<String?> lastFourDigits;
  final Value<String?> transactionId;
  final Value<String?> authorizationCode;
  final Value<String?> processedAt;
  final Value<String?> processedBy;
  final Value<String?> notes;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.ticketId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.amount = const Value.absent(),
    this.tipAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountCode = const Value.absent(),
    this.discountReason = const Value.absent(),
    this.cardType = const Value.absent(),
    this.lastFourDigits = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.authorizationCode = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.processedBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required String ticketId,
    this.invoiceId = const Value.absent(),
    required String paymentMethod,
    required double amount,
    this.tipAmount = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountCode = const Value.absent(),
    this.discountReason = const Value.absent(),
    this.cardType = const Value.absent(),
    this.lastFourDigits = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.authorizationCode = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.processedBy = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ticketId = Value(ticketId),
       paymentMethod = Value(paymentMethod),
       amount = Value(amount);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? ticketId,
    Expression<String>? invoiceId,
    Expression<String>? paymentMethod,
    Expression<double>? amount,
    Expression<double>? tipAmount,
    Expression<double>? taxAmount,
    Expression<double>? discountAmount,
    Expression<double>? totalAmount,
    Expression<String>? discountType,
    Expression<String>? discountCode,
    Expression<String>? discountReason,
    Expression<String>? cardType,
    Expression<String>? lastFourDigits,
    Expression<String>? transactionId,
    Expression<String>? authorizationCode,
    Expression<String>? processedAt,
    Expression<String>? processedBy,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ticketId != null) 'ticket_id': ticketId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (amount != null) 'amount': amount,
      if (tipAmount != null) 'tip_amount': tipAmount,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (discountType != null) 'discount_type': discountType,
      if (discountCode != null) 'discount_code': discountCode,
      if (discountReason != null) 'discount_reason': discountReason,
      if (cardType != null) 'card_type': cardType,
      if (lastFourDigits != null) 'last_four_digits': lastFourDigits,
      if (transactionId != null) 'transaction_id': transactionId,
      if (authorizationCode != null) 'authorization_code': authorizationCode,
      if (processedAt != null) 'processed_at': processedAt,
      if (processedBy != null) 'processed_by': processedBy,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? ticketId,
    Value<String?>? invoiceId,
    Value<String>? paymentMethod,
    Value<double>? amount,
    Value<double?>? tipAmount,
    Value<double?>? taxAmount,
    Value<double?>? discountAmount,
    Value<double?>? totalAmount,
    Value<String?>? discountType,
    Value<String?>? discountCode,
    Value<String?>? discountReason,
    Value<String?>? cardType,
    Value<String?>? lastFourDigits,
    Value<String?>? transactionId,
    Value<String?>? authorizationCode,
    Value<String?>? processedAt,
    Value<String?>? processedBy,
    Value<String?>? notes,
    Value<String?>? createdAt,
    Value<String?>? updatedAt,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      invoiceId: invoiceId ?? this.invoiceId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amount: amount ?? this.amount,
      tipAmount: tipAmount ?? this.tipAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      discountType: discountType ?? this.discountType,
      discountCode: discountCode ?? this.discountCode,
      discountReason: discountReason ?? this.discountReason,
      cardType: cardType ?? this.cardType,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      transactionId: transactionId ?? this.transactionId,
      authorizationCode: authorizationCode ?? this.authorizationCode,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ticketId.present) {
      map['ticket_id'] = Variable<String>(ticketId.value);
    }
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (tipAmount.present) {
      map['tip_amount'] = Variable<double>(tipAmount.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(discountType.value);
    }
    if (discountCode.present) {
      map['discount_code'] = Variable<String>(discountCode.value);
    }
    if (discountReason.present) {
      map['discount_reason'] = Variable<String>(discountReason.value);
    }
    if (cardType.present) {
      map['card_type'] = Variable<String>(cardType.value);
    }
    if (lastFourDigits.present) {
      map['last_four_digits'] = Variable<String>(lastFourDigits.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (authorizationCode.present) {
      map['authorization_code'] = Variable<String>(authorizationCode.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<String>(processedAt.value);
    }
    if (processedBy.present) {
      map['processed_by'] = Variable<String>(processedBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('invoiceId: $invoiceId, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('amount: $amount, ')
          ..write('tipAmount: $tipAmount, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('discountType: $discountType, ')
          ..write('discountCode: $discountCode, ')
          ..write('discountReason: $discountReason, ')
          ..write('cardType: $cardType, ')
          ..write('lastFourDigits: $lastFourDigits, ')
          ..write('transactionId: $transactionId, ')
          ..write('authorizationCode: $authorizationCode, ')
          ..write('processedAt: $processedAt, ')
          ..write('processedBy: $processedBy, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppointmentsTable extends Appointments
    with TableInfo<$AppointmentsTable, Appointment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appointmentStartDateTimeMeta =
      const VerificationMeta('appointmentStartDateTime');
  @override
  late final GeneratedColumn<String> appointmentStartDateTime =
      GeneratedColumn<String>(
        'start_datetime',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _appointmentEndDateTimeMeta =
      const VerificationMeta('appointmentEndDateTime');
  @override
  late final GeneratedColumn<String> appointmentEndDateTime =
      GeneratedColumn<String>(
        'end_datetime',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<
    List<Map<String, dynamic>>,
    String
  >
  services =
      GeneratedColumn<String>(
        'services',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Map<String, dynamic>>>(
        $AppointmentsTable.$converterservices,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isGroupBookingMeta = const VerificationMeta(
    'isGroupBooking',
  );
  @override
  late final GeneratedColumn<int> isGroupBooking = GeneratedColumn<int>(
    'is_group_booking',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupSizeMeta = const VerificationMeta(
    'groupSize',
  );
  @override
  late final GeneratedColumn<int> groupSize = GeneratedColumn<int>(
    'group_size',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedByMeta = const VerificationMeta(
    'lastModifiedBy',
  );
  @override
  late final GeneratedColumn<String> lastModifiedBy = GeneratedColumn<String>(
    'last_modified_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedDeviceMeta =
      const VerificationMeta('lastModifiedDevice');
  @override
  late final GeneratedColumn<String> lastModifiedDevice =
      GeneratedColumn<String>(
        'last_modified_device',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<String> confirmedAt = GeneratedColumn<String>(
    'confirmed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmationTypeMeta = const VerificationMeta(
    'confirmationType',
  );
  @override
  late final GeneratedColumn<String> confirmationType = GeneratedColumn<String>(
    'confirmation_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    employeeId,
    appointmentStartDateTime,
    appointmentEndDateTime,
    services,
    status,
    notes,
    isGroupBooking,
    groupSize,
    createdAt,
    updatedAt,
    lastModifiedBy,
    lastModifiedDevice,
    confirmedAt,
    confirmationType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Appointment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('start_datetime')) {
      context.handle(
        _appointmentStartDateTimeMeta,
        appointmentStartDateTime.isAcceptableOrUnknown(
          data['start_datetime']!,
          _appointmentStartDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appointmentStartDateTimeMeta);
    }
    if (data.containsKey('end_datetime')) {
      context.handle(
        _appointmentEndDateTimeMeta,
        appointmentEndDateTime.isAcceptableOrUnknown(
          data['end_datetime']!,
          _appointmentEndDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appointmentEndDateTimeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_group_booking')) {
      context.handle(
        _isGroupBookingMeta,
        isGroupBooking.isAcceptableOrUnknown(
          data['is_group_booking']!,
          _isGroupBookingMeta,
        ),
      );
    }
    if (data.containsKey('group_size')) {
      context.handle(
        _groupSizeMeta,
        groupSize.isAcceptableOrUnknown(data['group_size']!, _groupSizeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('last_modified_by')) {
      context.handle(
        _lastModifiedByMeta,
        lastModifiedBy.isAcceptableOrUnknown(
          data['last_modified_by']!,
          _lastModifiedByMeta,
        ),
      );
    }
    if (data.containsKey('last_modified_device')) {
      context.handle(
        _lastModifiedDeviceMeta,
        lastModifiedDevice.isAcceptableOrUnknown(
          data['last_modified_device']!,
          _lastModifiedDeviceMeta,
        ),
      );
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    }
    if (data.containsKey('confirmation_type')) {
      context.handle(
        _confirmationTypeMeta,
        confirmationType.isAcceptableOrUnknown(
          data['confirmation_type']!,
          _confirmationTypeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Appointment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Appointment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      appointmentStartDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_datetime'],
      )!,
      appointmentEndDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_datetime'],
      )!,
      services: $AppointmentsTable.$converterservices.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}services'],
        )!,
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isGroupBooking: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_group_booking'],
      ),
      groupSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_size'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
      lastModifiedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_modified_by'],
      ),
      lastModifiedDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_modified_device'],
      ),
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmed_at'],
      ),
      confirmationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmation_type'],
      ),
    );
  }

  @override
  $AppointmentsTable createAlias(String alias) {
    return $AppointmentsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<Map<String, dynamic>>, String> $converterservices =
      const ServicesJsonConverter();
}

class Appointment extends DataClass implements Insertable<Appointment> {
  final String id;
  final String customerId;
  final int employeeId;
  final String appointmentStartDateTime;
  final String appointmentEndDateTime;
  final List<Map<String, dynamic>> services;
  final String? status;
  final String? notes;
  final int? isGroupBooking;
  final int? groupSize;
  final String createdAt;
  final String updatedAt;
  final String? lastModifiedBy;
  final String? lastModifiedDevice;
  final String? confirmedAt;
  final String? confirmationType;
  const Appointment({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.appointmentStartDateTime,
    required this.appointmentEndDateTime,
    required this.services,
    this.status,
    this.notes,
    this.isGroupBooking,
    this.groupSize,
    required this.createdAt,
    required this.updatedAt,
    this.lastModifiedBy,
    this.lastModifiedDevice,
    this.confirmedAt,
    this.confirmationType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['employee_id'] = Variable<int>(employeeId);
    map['start_datetime'] = Variable<String>(appointmentStartDateTime);
    map['end_datetime'] = Variable<String>(appointmentEndDateTime);
    {
      map['services'] = Variable<String>(
        $AppointmentsTable.$converterservices.toSql(services),
      );
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || isGroupBooking != null) {
      map['is_group_booking'] = Variable<int>(isGroupBooking);
    }
    if (!nullToAbsent || groupSize != null) {
      map['group_size'] = Variable<int>(groupSize);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || lastModifiedBy != null) {
      map['last_modified_by'] = Variable<String>(lastModifiedBy);
    }
    if (!nullToAbsent || lastModifiedDevice != null) {
      map['last_modified_device'] = Variable<String>(lastModifiedDevice);
    }
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<String>(confirmedAt);
    }
    if (!nullToAbsent || confirmationType != null) {
      map['confirmation_type'] = Variable<String>(confirmationType);
    }
    return map;
  }

  AppointmentsCompanion toCompanion(bool nullToAbsent) {
    return AppointmentsCompanion(
      id: Value(id),
      customerId: Value(customerId),
      employeeId: Value(employeeId),
      appointmentStartDateTime: Value(appointmentStartDateTime),
      appointmentEndDateTime: Value(appointmentEndDateTime),
      services: Value(services),
      status: status == null && nullToAbsent
          ? const Value.absent()
          : Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isGroupBooking: isGroupBooking == null && nullToAbsent
          ? const Value.absent()
          : Value(isGroupBooking),
      groupSize: groupSize == null && nullToAbsent
          ? const Value.absent()
          : Value(groupSize),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastModifiedBy: lastModifiedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModifiedBy),
      lastModifiedDevice: lastModifiedDevice == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModifiedDevice),
      confirmedAt: confirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAt),
      confirmationType: confirmationType == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmationType),
    );
  }

  factory Appointment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Appointment(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      appointmentStartDateTime: serializer.fromJson<String>(
        json['appointmentStartDateTime'],
      ),
      appointmentEndDateTime: serializer.fromJson<String>(
        json['appointmentEndDateTime'],
      ),
      services: serializer.fromJson<List<Map<String, dynamic>>>(
        json['services'],
      ),
      status: serializer.fromJson<String?>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      isGroupBooking: serializer.fromJson<int?>(json['isGroupBooking']),
      groupSize: serializer.fromJson<int?>(json['groupSize']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      lastModifiedBy: serializer.fromJson<String?>(json['lastModifiedBy']),
      lastModifiedDevice: serializer.fromJson<String?>(
        json['lastModifiedDevice'],
      ),
      confirmedAt: serializer.fromJson<String?>(json['confirmedAt']),
      confirmationType: serializer.fromJson<String?>(json['confirmationType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'employeeId': serializer.toJson<int>(employeeId),
      'appointmentStartDateTime': serializer.toJson<String>(
        appointmentStartDateTime,
      ),
      'appointmentEndDateTime': serializer.toJson<String>(
        appointmentEndDateTime,
      ),
      'services': serializer.toJson<List<Map<String, dynamic>>>(services),
      'status': serializer.toJson<String?>(status),
      'notes': serializer.toJson<String?>(notes),
      'isGroupBooking': serializer.toJson<int?>(isGroupBooking),
      'groupSize': serializer.toJson<int?>(groupSize),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'lastModifiedBy': serializer.toJson<String?>(lastModifiedBy),
      'lastModifiedDevice': serializer.toJson<String?>(lastModifiedDevice),
      'confirmedAt': serializer.toJson<String?>(confirmedAt),
      'confirmationType': serializer.toJson<String?>(confirmationType),
    };
  }

  Appointment copyWith({
    String? id,
    String? customerId,
    int? employeeId,
    String? appointmentStartDateTime,
    String? appointmentEndDateTime,
    List<Map<String, dynamic>>? services,
    Value<String?> status = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<int?> isGroupBooking = const Value.absent(),
    Value<int?> groupSize = const Value.absent(),
    String? createdAt,
    String? updatedAt,
    Value<String?> lastModifiedBy = const Value.absent(),
    Value<String?> lastModifiedDevice = const Value.absent(),
    Value<String?> confirmedAt = const Value.absent(),
    Value<String?> confirmationType = const Value.absent(),
  }) => Appointment(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    employeeId: employeeId ?? this.employeeId,
    appointmentStartDateTime:
        appointmentStartDateTime ?? this.appointmentStartDateTime,
    appointmentEndDateTime:
        appointmentEndDateTime ?? this.appointmentEndDateTime,
    services: services ?? this.services,
    status: status.present ? status.value : this.status,
    notes: notes.present ? notes.value : this.notes,
    isGroupBooking: isGroupBooking.present
        ? isGroupBooking.value
        : this.isGroupBooking,
    groupSize: groupSize.present ? groupSize.value : this.groupSize,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    lastModifiedBy: lastModifiedBy.present
        ? lastModifiedBy.value
        : this.lastModifiedBy,
    lastModifiedDevice: lastModifiedDevice.present
        ? lastModifiedDevice.value
        : this.lastModifiedDevice,
    confirmedAt: confirmedAt.present ? confirmedAt.value : this.confirmedAt,
    confirmationType: confirmationType.present
        ? confirmationType.value
        : this.confirmationType,
  );
  Appointment copyWithCompanion(AppointmentsCompanion data) {
    return Appointment(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      appointmentStartDateTime: data.appointmentStartDateTime.present
          ? data.appointmentStartDateTime.value
          : this.appointmentStartDateTime,
      appointmentEndDateTime: data.appointmentEndDateTime.present
          ? data.appointmentEndDateTime.value
          : this.appointmentEndDateTime,
      services: data.services.present ? data.services.value : this.services,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      isGroupBooking: data.isGroupBooking.present
          ? data.isGroupBooking.value
          : this.isGroupBooking,
      groupSize: data.groupSize.present ? data.groupSize.value : this.groupSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastModifiedBy: data.lastModifiedBy.present
          ? data.lastModifiedBy.value
          : this.lastModifiedBy,
      lastModifiedDevice: data.lastModifiedDevice.present
          ? data.lastModifiedDevice.value
          : this.lastModifiedDevice,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
      confirmationType: data.confirmationType.present
          ? data.confirmationType.value
          : this.confirmationType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Appointment(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('employeeId: $employeeId, ')
          ..write('appointmentStartDateTime: $appointmentStartDateTime, ')
          ..write('appointmentEndDateTime: $appointmentEndDateTime, ')
          ..write('services: $services, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isGroupBooking: $isGroupBooking, ')
          ..write('groupSize: $groupSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastModifiedBy: $lastModifiedBy, ')
          ..write('lastModifiedDevice: $lastModifiedDevice, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('confirmationType: $confirmationType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    employeeId,
    appointmentStartDateTime,
    appointmentEndDateTime,
    services,
    status,
    notes,
    isGroupBooking,
    groupSize,
    createdAt,
    updatedAt,
    lastModifiedBy,
    lastModifiedDevice,
    confirmedAt,
    confirmationType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Appointment &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.employeeId == this.employeeId &&
          other.appointmentStartDateTime == this.appointmentStartDateTime &&
          other.appointmentEndDateTime == this.appointmentEndDateTime &&
          other.services == this.services &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.isGroupBooking == this.isGroupBooking &&
          other.groupSize == this.groupSize &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastModifiedBy == this.lastModifiedBy &&
          other.lastModifiedDevice == this.lastModifiedDevice &&
          other.confirmedAt == this.confirmedAt &&
          other.confirmationType == this.confirmationType);
}

class AppointmentsCompanion extends UpdateCompanion<Appointment> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<int> employeeId;
  final Value<String> appointmentStartDateTime;
  final Value<String> appointmentEndDateTime;
  final Value<List<Map<String, dynamic>>> services;
  final Value<String?> status;
  final Value<String?> notes;
  final Value<int?> isGroupBooking;
  final Value<int?> groupSize;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<String?> lastModifiedBy;
  final Value<String?> lastModifiedDevice;
  final Value<String?> confirmedAt;
  final Value<String?> confirmationType;
  final Value<int> rowid;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.appointmentStartDateTime = const Value.absent(),
    this.appointmentEndDateTime = const Value.absent(),
    this.services = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isGroupBooking = const Value.absent(),
    this.groupSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastModifiedBy = const Value.absent(),
    this.lastModifiedDevice = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.confirmationType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppointmentsCompanion.insert({
    required String id,
    required String customerId,
    required int employeeId,
    required String appointmentStartDateTime,
    required String appointmentEndDateTime,
    required List<Map<String, dynamic>> services,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isGroupBooking = const Value.absent(),
    this.groupSize = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.lastModifiedBy = const Value.absent(),
    this.lastModifiedDevice = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.confirmationType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       employeeId = Value(employeeId),
       appointmentStartDateTime = Value(appointmentStartDateTime),
       appointmentEndDateTime = Value(appointmentEndDateTime),
       services = Value(services),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Appointment> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<int>? employeeId,
    Expression<String>? appointmentStartDateTime,
    Expression<String>? appointmentEndDateTime,
    Expression<String>? services,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<int>? isGroupBooking,
    Expression<int>? groupSize,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? lastModifiedBy,
    Expression<String>? lastModifiedDevice,
    Expression<String>? confirmedAt,
    Expression<String>? confirmationType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (employeeId != null) 'employee_id': employeeId,
      if (appointmentStartDateTime != null)
        'start_datetime': appointmentStartDateTime,
      if (appointmentEndDateTime != null)
        'end_datetime': appointmentEndDateTime,
      if (services != null) 'services': services,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (isGroupBooking != null) 'is_group_booking': isGroupBooking,
      if (groupSize != null) 'group_size': groupSize,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastModifiedBy != null) 'last_modified_by': lastModifiedBy,
      if (lastModifiedDevice != null)
        'last_modified_device': lastModifiedDevice,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (confirmationType != null) 'confirmation_type': confirmationType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppointmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<int>? employeeId,
    Value<String>? appointmentStartDateTime,
    Value<String>? appointmentEndDateTime,
    Value<List<Map<String, dynamic>>>? services,
    Value<String?>? status,
    Value<String?>? notes,
    Value<int?>? isGroupBooking,
    Value<int?>? groupSize,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<String?>? lastModifiedBy,
    Value<String?>? lastModifiedDevice,
    Value<String?>? confirmedAt,
    Value<String?>? confirmationType,
    Value<int>? rowid,
  }) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      employeeId: employeeId ?? this.employeeId,
      appointmentStartDateTime:
          appointmentStartDateTime ?? this.appointmentStartDateTime,
      appointmentEndDateTime:
          appointmentEndDateTime ?? this.appointmentEndDateTime,
      services: services ?? this.services,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isGroupBooking: isGroupBooking ?? this.isGroupBooking,
      groupSize: groupSize ?? this.groupSize,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastModifiedBy: lastModifiedBy ?? this.lastModifiedBy,
      lastModifiedDevice: lastModifiedDevice ?? this.lastModifiedDevice,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      confirmationType: confirmationType ?? this.confirmationType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (appointmentStartDateTime.present) {
      map['start_datetime'] = Variable<String>(appointmentStartDateTime.value);
    }
    if (appointmentEndDateTime.present) {
      map['end_datetime'] = Variable<String>(appointmentEndDateTime.value);
    }
    if (services.present) {
      map['services'] = Variable<String>(
        $AppointmentsTable.$converterservices.toSql(services.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isGroupBooking.present) {
      map['is_group_booking'] = Variable<int>(isGroupBooking.value);
    }
    if (groupSize.present) {
      map['group_size'] = Variable<int>(groupSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (lastModifiedBy.present) {
      map['last_modified_by'] = Variable<String>(lastModifiedBy.value);
    }
    if (lastModifiedDevice.present) {
      map['last_modified_device'] = Variable<String>(lastModifiedDevice.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<String>(confirmedAt.value);
    }
    if (confirmationType.present) {
      map['confirmation_type'] = Variable<String>(confirmationType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentsCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('employeeId: $employeeId, ')
          ..write('appointmentStartDateTime: $appointmentStartDateTime, ')
          ..write('appointmentEndDateTime: $appointmentEndDateTime, ')
          ..write('services: $services, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('isGroupBooking: $isGroupBooking, ')
          ..write('groupSize: $groupSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastModifiedBy: $lastModifiedBy, ')
          ..write('lastModifiedDevice: $lastModifiedDevice, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('confirmationType: $confirmationType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ServiceCategoriesTable extends ServiceCategories
    with TableInfo<$ServiceCategoriesTable, ServiceCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, icon];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
    );
  }

  @override
  $ServiceCategoriesTable createAlias(String alias) {
    return $ServiceCategoriesTable(attachedDatabase, alias);
  }
}

class ServiceCategory extends DataClass implements Insertable<ServiceCategory> {
  final String? id;
  final String name;
  final String? color;
  final String? icon;
  const ServiceCategory({this.id, required this.name, this.color, this.icon});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  ServiceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ServiceCategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory ServiceCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceCategory(
      id: serializer.fromJson<String?>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  ServiceCategory copyWith({
    Value<String?> id = const Value.absent(),
    String? name,
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
  }) => ServiceCategory(
    id: id.present ? id.value : this.id,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
  );
  ServiceCategory copyWithCompanion(ServiceCategoriesCompanion data) {
    return ServiceCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon);
}

class ServiceCategoriesCompanion extends UpdateCompanion<ServiceCategory> {
  final Value<String?> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<int> rowid;
  const ServiceCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ServiceCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ServiceCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ServiceCategoriesCompanion copyWith({
    Value<String?>? id,
    Value<String>? name,
    Value<String?>? color,
    Value<String?>? icon,
    Value<int>? rowid,
  }) {
    return ServiceCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeeServiceCategoriesTable extends EmployeeServiceCategories
    with TableInfo<$EmployeeServiceCategoriesTable, EmployeeServiceCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeeServiceCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, employeeId, categoryName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employee_service_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmployeeServiceCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmployeeServiceCategory map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeServiceCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      ),
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      ),
    );
  }

  @override
  $EmployeeServiceCategoriesTable createAlias(String alias) {
    return $EmployeeServiceCategoriesTable(attachedDatabase, alias);
  }
}

class EmployeeServiceCategory extends DataClass
    implements Insertable<EmployeeServiceCategory> {
  final String? id;
  final int employeeId;
  final String? categoryName;
  const EmployeeServiceCategory({
    this.id,
    required this.employeeId,
    this.categoryName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    map['employee_id'] = Variable<int>(employeeId);
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    return map;
  }

  EmployeeServiceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return EmployeeServiceCategoriesCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      employeeId: Value(employeeId),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
    );
  }

  factory EmployeeServiceCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeServiceCategory(
      id: serializer.fromJson<String?>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'categoryName': serializer.toJson<String?>(categoryName),
    };
  }

  EmployeeServiceCategory copyWith({
    Value<String?> id = const Value.absent(),
    int? employeeId,
    Value<String?> categoryName = const Value.absent(),
  }) => EmployeeServiceCategory(
    id: id.present ? id.value : this.id,
    employeeId: employeeId ?? this.employeeId,
    categoryName: categoryName.present ? categoryName.value : this.categoryName,
  );
  EmployeeServiceCategory copyWithCompanion(
    EmployeeServiceCategoriesCompanion data,
  ) {
    return EmployeeServiceCategory(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeServiceCategory(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('categoryName: $categoryName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, employeeId, categoryName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeServiceCategory &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.categoryName == this.categoryName);
}

class EmployeeServiceCategoriesCompanion
    extends UpdateCompanion<EmployeeServiceCategory> {
  final Value<String?> id;
  final Value<int> employeeId;
  final Value<String?> categoryName;
  final Value<int> rowid;
  const EmployeeServiceCategoriesCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeServiceCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int employeeId,
    this.categoryName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : employeeId = Value(employeeId);
  static Insertable<EmployeeServiceCategory> custom({
    Expression<String>? id,
    Expression<int>? employeeId,
    Expression<String>? categoryName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (categoryName != null) 'category_name': categoryName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeServiceCategoriesCompanion copyWith({
    Value<String?>? id,
    Value<int>? employeeId,
    Value<String?>? categoryName,
    Value<int>? rowid,
  }) {
    return EmployeeServiceCategoriesCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      categoryName: categoryName ?? this.categoryName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeServiceCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('categoryName: $categoryName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dataTypeMeta = const VerificationMeta(
    'dataType',
  );
  @override
  late final GeneratedColumn<String> dataType = GeneratedColumn<String>(
    'data_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<int> isSystem = GeneratedColumn<int>(
    'is_system',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    value,
    category,
    dataType,
    description,
    isSystem,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('data_type')) {
      context.handle(
        _dataTypeMeta,
        dataType.isAcceptableOrUnknown(data['data_type']!, _dataTypeMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      dataType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_type'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_system'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  final String? category;
  final String? dataType;
  final String? description;
  final int? isSystem;
  final String? createdAt;
  final String? updatedAt;
  const Setting({
    required this.key,
    required this.value,
    this.category,
    this.dataType,
    this.description,
    this.isSystem,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || dataType != null) {
      map['data_type'] = Variable<String>(dataType);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || isSystem != null) {
      map['is_system'] = Variable<int>(isSystem);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: Value(value),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      dataType: dataType == null && nullToAbsent
          ? const Value.absent()
          : Value(dataType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isSystem: isSystem == null && nullToAbsent
          ? const Value.absent()
          : Value(isSystem),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      category: serializer.fromJson<String?>(json['category']),
      dataType: serializer.fromJson<String?>(json['dataType']),
      description: serializer.fromJson<String?>(json['description']),
      isSystem: serializer.fromJson<int?>(json['isSystem']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'category': serializer.toJson<String?>(category),
      'dataType': serializer.toJson<String?>(dataType),
      'description': serializer.toJson<String?>(description),
      'isSystem': serializer.toJson<int?>(isSystem),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  Setting copyWith({
    String? key,
    String? value,
    Value<String?> category = const Value.absent(),
    Value<String?> dataType = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<int?> isSystem = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
    Value<String?> updatedAt = const Value.absent(),
  }) => Setting(
    key: key ?? this.key,
    value: value ?? this.value,
    category: category.present ? category.value : this.category,
    dataType: dataType.present ? dataType.value : this.dataType,
    description: description.present ? description.value : this.description,
    isSystem: isSystem.present ? isSystem.value : this.isSystem,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      category: data.category.present ? data.category.value : this.category,
      dataType: data.dataType.present ? data.dataType.value : this.dataType,
      description: data.description.present
          ? data.description.value
          : this.description,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('category: $category, ')
          ..write('dataType: $dataType, ')
          ..write('description: $description, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    value,
    category,
    dataType,
    description,
    isSystem,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.key == this.key &&
          other.value == this.value &&
          other.category == this.category &&
          other.dataType == this.dataType &&
          other.description == this.description &&
          other.isSystem == this.isSystem &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<String?> category;
  final Value<String?> dataType;
  final Value<String?> description;
  final Value<int?> isSystem;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.category = const Value.absent(),
    this.dataType = const Value.absent(),
    this.description = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.category = const Value.absent(),
    this.dataType = const Value.absent(),
    this.description = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? category,
    Expression<String>? dataType,
    Expression<String>? description,
    Expression<int>? isSystem,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (category != null) 'category': category,
      if (dataType != null) 'data_type': dataType,
      if (description != null) 'description': description,
      if (isSystem != null) 'is_system': isSystem,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<String?>? category,
    Value<String?>? dataType,
    Value<String?>? description,
    Value<int?>? isSystem,
    Value<String?>? createdAt,
    Value<String?>? updatedAt,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      category: category ?? this.category,
      dataType: dataType ?? this.dataType,
      description: description ?? this.description,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (dataType.present) {
      map['data_type'] = Variable<String>(dataType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<int>(isSystem.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('category: $category, ')
          ..write('dataType: $dataType, ')
          ..write('description: $description, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TechnicianSchedulesTable extends TechnicianSchedules
    with TableInfo<$TechnicianSchedulesTable, TechnicianSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TechnicianSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<String> dayOfWeek = GeneratedColumn<String>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isScheduledOffMeta = const VerificationMeta(
    'isScheduledOff',
  );
  @override
  late final GeneratedColumn<int> isScheduledOff = GeneratedColumn<int>(
    'is_scheduled_off',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<int> startTime = GeneratedColumn<int>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<int> endTime = GeneratedColumn<int>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<String> effectiveDate = GeneratedColumn<String>(
    'effective_date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    dayOfWeek,
    isScheduledOff,
    startTime,
    endTime,
    effectiveDate,
    notes,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'technician_schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<TechnicianSchedule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('is_scheduled_off')) {
      context.handle(
        _isScheduledOffMeta,
        isScheduledOff.isAcceptableOrUnknown(
          data['is_scheduled_off']!,
          _isScheduledOffMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isScheduledOffMeta);
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    } else if (isInserting) {
      context.missing(_isActiveMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TechnicianSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TechnicianSchedule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day_of_week'],
      )!,
      isScheduledOff: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_scheduled_off'],
      )!,
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_time'],
      ),
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_time'],
      ),
      effectiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}effective_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $TechnicianSchedulesTable createAlias(String alias) {
    return $TechnicianSchedulesTable(attachedDatabase, alias);
  }
}

class TechnicianSchedule extends DataClass
    implements Insertable<TechnicianSchedule> {
  final String id;
  final int employeeId;
  final String dayOfWeek;
  final int isScheduledOff;
  final int? startTime;
  final int? endTime;
  final String? effectiveDate;
  final String? notes;
  final int isActive;
  final String? createdAt;
  final String? updatedAt;
  const TechnicianSchedule({
    required this.id,
    required this.employeeId,
    required this.dayOfWeek,
    required this.isScheduledOff,
    this.startTime,
    this.endTime,
    this.effectiveDate,
    this.notes,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<int>(employeeId);
    map['day_of_week'] = Variable<String>(dayOfWeek);
    map['is_scheduled_off'] = Variable<int>(isScheduledOff);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<int>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<int>(endTime);
    }
    if (!nullToAbsent || effectiveDate != null) {
      map['effective_date'] = Variable<String>(effectiveDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<int>(isActive);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    return map;
  }

  TechnicianSchedulesCompanion toCompanion(bool nullToAbsent) {
    return TechnicianSchedulesCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      dayOfWeek: Value(dayOfWeek),
      isScheduledOff: Value(isScheduledOff),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      effectiveDate: effectiveDate == null && nullToAbsent
          ? const Value.absent()
          : Value(effectiveDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isActive: Value(isActive),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory TechnicianSchedule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TechnicianSchedule(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      dayOfWeek: serializer.fromJson<String>(json['dayOfWeek']),
      isScheduledOff: serializer.fromJson<int>(json['isScheduledOff']),
      startTime: serializer.fromJson<int?>(json['startTime']),
      endTime: serializer.fromJson<int?>(json['endTime']),
      effectiveDate: serializer.fromJson<String?>(json['effectiveDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<int>(json['isActive']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      updatedAt: serializer.fromJson<String?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'dayOfWeek': serializer.toJson<String>(dayOfWeek),
      'isScheduledOff': serializer.toJson<int>(isScheduledOff),
      'startTime': serializer.toJson<int?>(startTime),
      'endTime': serializer.toJson<int?>(endTime),
      'effectiveDate': serializer.toJson<String?>(effectiveDate),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<int>(isActive),
      'createdAt': serializer.toJson<String?>(createdAt),
      'updatedAt': serializer.toJson<String?>(updatedAt),
    };
  }

  TechnicianSchedule copyWith({
    String? id,
    int? employeeId,
    String? dayOfWeek,
    int? isScheduledOff,
    Value<int?> startTime = const Value.absent(),
    Value<int?> endTime = const Value.absent(),
    Value<String?> effectiveDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? isActive,
    Value<String?> createdAt = const Value.absent(),
    Value<String?> updatedAt = const Value.absent(),
  }) => TechnicianSchedule(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    isScheduledOff: isScheduledOff ?? this.isScheduledOff,
    startTime: startTime.present ? startTime.value : this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    effectiveDate: effectiveDate.present
        ? effectiveDate.value
        : this.effectiveDate,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  TechnicianSchedule copyWithCompanion(TechnicianSchedulesCompanion data) {
    return TechnicianSchedule(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      isScheduledOff: data.isScheduledOff.present
          ? data.isScheduledOff.value
          : this.isScheduledOff,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      effectiveDate: data.effectiveDate.present
          ? data.effectiveDate.value
          : this.effectiveDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TechnicianSchedule(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('isScheduledOff: $isScheduledOff, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeId,
    dayOfWeek,
    isScheduledOff,
    startTime,
    endTime,
    effectiveDate,
    notes,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TechnicianSchedule &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.dayOfWeek == this.dayOfWeek &&
          other.isScheduledOff == this.isScheduledOff &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.effectiveDate == this.effectiveDate &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TechnicianSchedulesCompanion extends UpdateCompanion<TechnicianSchedule> {
  final Value<String> id;
  final Value<int> employeeId;
  final Value<String> dayOfWeek;
  final Value<int> isScheduledOff;
  final Value<int?> startTime;
  final Value<int?> endTime;
  final Value<String?> effectiveDate;
  final Value<String?> notes;
  final Value<int> isActive;
  final Value<String?> createdAt;
  final Value<String?> updatedAt;
  final Value<int> rowid;
  const TechnicianSchedulesCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.isScheduledOff = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TechnicianSchedulesCompanion.insert({
    required String id,
    required int employeeId,
    required String dayOfWeek,
    required int isScheduledOff,
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.notes = const Value.absent(),
    required int isActive,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employeeId = Value(employeeId),
       dayOfWeek = Value(dayOfWeek),
       isScheduledOff = Value(isScheduledOff),
       isActive = Value(isActive);
  static Insertable<TechnicianSchedule> custom({
    Expression<String>? id,
    Expression<int>? employeeId,
    Expression<String>? dayOfWeek,
    Expression<int>? isScheduledOff,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<String>? effectiveDate,
    Expression<String>? notes,
    Expression<int>? isActive,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (isScheduledOff != null) 'is_scheduled_off': isScheduledOff,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TechnicianSchedulesCompanion copyWith({
    Value<String>? id,
    Value<int>? employeeId,
    Value<String>? dayOfWeek,
    Value<int>? isScheduledOff,
    Value<int?>? startTime,
    Value<int?>? endTime,
    Value<String?>? effectiveDate,
    Value<String?>? notes,
    Value<int>? isActive,
    Value<String?>? createdAt,
    Value<String?>? updatedAt,
    Value<int>? rowid,
  }) {
    return TechnicianSchedulesCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isScheduledOff: isScheduledOff ?? this.isScheduledOff,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<String>(dayOfWeek.value);
    }
    if (isScheduledOff.present) {
      map['is_scheduled_off'] = Variable<int>(isScheduledOff.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<String>(effectiveDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TechnicianSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('isScheduledOff: $isScheduledOff, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeEntriesTable extends TimeEntries
    with TableInfo<$TimeEntriesTable, TimeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<int> employeeId = GeneratedColumn<int>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clockInMeta = const VerificationMeta(
    'clockIn',
  );
  @override
  late final GeneratedColumn<String> clockIn = GeneratedColumn<String>(
    'clock_in',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clockOutMeta = const VerificationMeta(
    'clockOut',
  );
  @override
  late final GeneratedColumn<String> clockOut = GeneratedColumn<String>(
    'clock_out',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breakMinutesMeta = const VerificationMeta(
    'breakMinutes',
  );
  @override
  late final GeneratedColumn<int> breakMinutes = GeneratedColumn<int>(
    'break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalHoursMeta = const VerificationMeta(
    'totalHours',
  );
  @override
  late final GeneratedColumn<double> totalHours = GeneratedColumn<double>(
    'total_hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _editedByMeta = const VerificationMeta(
    'editedBy',
  );
  @override
  late final GeneratedColumn<String> editedBy = GeneratedColumn<String>(
    'edited_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editReasonMeta = const VerificationMeta(
    'editReason',
  );
  @override
  late final GeneratedColumn<String> editReason = GeneratedColumn<String>(
    'edit_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    clockIn,
    clockOut,
    breakMinutes,
    totalHours,
    status,
    editedBy,
    editReason,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('clock_in')) {
      context.handle(
        _clockInMeta,
        clockIn.isAcceptableOrUnknown(data['clock_in']!, _clockInMeta),
      );
    } else if (isInserting) {
      context.missing(_clockInMeta);
    }
    if (data.containsKey('clock_out')) {
      context.handle(
        _clockOutMeta,
        clockOut.isAcceptableOrUnknown(data['clock_out']!, _clockOutMeta),
      );
    }
    if (data.containsKey('break_minutes')) {
      context.handle(
        _breakMinutesMeta,
        breakMinutes.isAcceptableOrUnknown(
          data['break_minutes']!,
          _breakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('total_hours')) {
      context.handle(
        _totalHoursMeta,
        totalHours.isAcceptableOrUnknown(data['total_hours']!, _totalHoursMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('edited_by')) {
      context.handle(
        _editedByMeta,
        editedBy.isAcceptableOrUnknown(data['edited_by']!, _editedByMeta),
      );
    }
    if (data.containsKey('edit_reason')) {
      context.handle(
        _editReasonMeta,
        editReason.isAcceptableOrUnknown(data['edit_reason']!, _editReasonMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      clockIn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clock_in'],
      )!,
      clockOut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}clock_out'],
      ),
      breakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_minutes'],
      )!,
      totalHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_hours'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      editedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edited_by'],
      ),
      editReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edit_reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TimeEntriesTable createAlias(String alias) {
    return $TimeEntriesTable(attachedDatabase, alias);
  }
}

class TimeEntry extends DataClass implements Insertable<TimeEntry> {
  final String id;
  final int employeeId;
  final String clockIn;
  final String? clockOut;
  final int breakMinutes;
  final double? totalHours;
  final String status;
  final String? editedBy;
  final String? editReason;
  final String createdAt;
  final String updatedAt;
  const TimeEntry({
    required this.id,
    required this.employeeId,
    required this.clockIn,
    this.clockOut,
    required this.breakMinutes,
    this.totalHours,
    required this.status,
    this.editedBy,
    this.editReason,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<int>(employeeId);
    map['clock_in'] = Variable<String>(clockIn);
    if (!nullToAbsent || clockOut != null) {
      map['clock_out'] = Variable<String>(clockOut);
    }
    map['break_minutes'] = Variable<int>(breakMinutes);
    if (!nullToAbsent || totalHours != null) {
      map['total_hours'] = Variable<double>(totalHours);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || editedBy != null) {
      map['edited_by'] = Variable<String>(editedBy);
    }
    if (!nullToAbsent || editReason != null) {
      map['edit_reason'] = Variable<String>(editReason);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  TimeEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimeEntriesCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      clockIn: Value(clockIn),
      clockOut: clockOut == null && nullToAbsent
          ? const Value.absent()
          : Value(clockOut),
      breakMinutes: Value(breakMinutes),
      totalHours: totalHours == null && nullToAbsent
          ? const Value.absent()
          : Value(totalHours),
      status: Value(status),
      editedBy: editedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(editedBy),
      editReason: editReason == null && nullToAbsent
          ? const Value.absent()
          : Value(editReason),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TimeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeEntry(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<int>(json['employeeId']),
      clockIn: serializer.fromJson<String>(json['clockIn']),
      clockOut: serializer.fromJson<String?>(json['clockOut']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      totalHours: serializer.fromJson<double?>(json['totalHours']),
      status: serializer.fromJson<String>(json['status']),
      editedBy: serializer.fromJson<String?>(json['editedBy']),
      editReason: serializer.fromJson<String?>(json['editReason']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'clockIn': serializer.toJson<String>(clockIn),
      'clockOut': serializer.toJson<String?>(clockOut),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'totalHours': serializer.toJson<double?>(totalHours),
      'status': serializer.toJson<String>(status),
      'editedBy': serializer.toJson<String?>(editedBy),
      'editReason': serializer.toJson<String?>(editReason),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  TimeEntry copyWith({
    String? id,
    int? employeeId,
    String? clockIn,
    Value<String?> clockOut = const Value.absent(),
    int? breakMinutes,
    Value<double?> totalHours = const Value.absent(),
    String? status,
    Value<String?> editedBy = const Value.absent(),
    Value<String?> editReason = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => TimeEntry(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    clockIn: clockIn ?? this.clockIn,
    clockOut: clockOut.present ? clockOut.value : this.clockOut,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    totalHours: totalHours.present ? totalHours.value : this.totalHours,
    status: status ?? this.status,
    editedBy: editedBy.present ? editedBy.value : this.editedBy,
    editReason: editReason.present ? editReason.value : this.editReason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TimeEntry copyWithCompanion(TimeEntriesCompanion data) {
    return TimeEntry(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      clockIn: data.clockIn.present ? data.clockIn.value : this.clockIn,
      clockOut: data.clockOut.present ? data.clockOut.value : this.clockOut,
      breakMinutes: data.breakMinutes.present
          ? data.breakMinutes.value
          : this.breakMinutes,
      totalHours: data.totalHours.present
          ? data.totalHours.value
          : this.totalHours,
      status: data.status.present ? data.status.value : this.status,
      editedBy: data.editedBy.present ? data.editedBy.value : this.editedBy,
      editReason: data.editReason.present
          ? data.editReason.value
          : this.editReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntry(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('totalHours: $totalHours, ')
          ..write('status: $status, ')
          ..write('editedBy: $editedBy, ')
          ..write('editReason: $editReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeId,
    clockIn,
    clockOut,
    breakMinutes,
    totalHours,
    status,
    editedBy,
    editReason,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeEntry &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.clockIn == this.clockIn &&
          other.clockOut == this.clockOut &&
          other.breakMinutes == this.breakMinutes &&
          other.totalHours == this.totalHours &&
          other.status == this.status &&
          other.editedBy == this.editedBy &&
          other.editReason == this.editReason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TimeEntriesCompanion extends UpdateCompanion<TimeEntry> {
  final Value<String> id;
  final Value<int> employeeId;
  final Value<String> clockIn;
  final Value<String?> clockOut;
  final Value<int> breakMinutes;
  final Value<double?> totalHours;
  final Value<String> status;
  final Value<String?> editedBy;
  final Value<String?> editReason;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const TimeEntriesCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.status = const Value.absent(),
    this.editedBy = const Value.absent(),
    this.editReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeEntriesCompanion.insert({
    required String id,
    required int employeeId,
    required String clockIn,
    this.clockOut = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.status = const Value.absent(),
    this.editedBy = const Value.absent(),
    this.editReason = const Value.absent(),
    required String createdAt,
    required String updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employeeId = Value(employeeId),
       clockIn = Value(clockIn),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TimeEntry> custom({
    Expression<String>? id,
    Expression<int>? employeeId,
    Expression<String>? clockIn,
    Expression<String>? clockOut,
    Expression<int>? breakMinutes,
    Expression<double>? totalHours,
    Expression<String>? status,
    Expression<String>? editedBy,
    Expression<String>? editReason,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (clockIn != null) 'clock_in': clockIn,
      if (clockOut != null) 'clock_out': clockOut,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (totalHours != null) 'total_hours': totalHours,
      if (status != null) 'status': status,
      if (editedBy != null) 'edited_by': editedBy,
      if (editReason != null) 'edit_reason': editReason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? employeeId,
    Value<String>? clockIn,
    Value<String?>? clockOut,
    Value<int>? breakMinutes,
    Value<double?>? totalHours,
    Value<String>? status,
    Value<String?>? editedBy,
    Value<String?>? editReason,
    Value<String>? createdAt,
    Value<String>? updatedAt,
    Value<int>? rowid,
  }) {
    return TimeEntriesCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      totalHours: totalHours ?? this.totalHours,
      status: status ?? this.status,
      editedBy: editedBy ?? this.editedBy,
      editReason: editReason ?? this.editReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (clockIn.present) {
      map['clock_in'] = Variable<String>(clockIn.value);
    }
    if (clockOut.present) {
      map['clock_out'] = Variable<String>(clockOut.value);
    }
    if (breakMinutes.present) {
      map['break_minutes'] = Variable<int>(breakMinutes.value);
    }
    if (totalHours.present) {
      map['total_hours'] = Variable<double>(totalHours.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (editedBy.present) {
      map['edited_by'] = Variable<String>(editedBy.value);
    }
    if (editReason.present) {
      map['edit_reason'] = Variable<String>(editReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('totalHours: $totalHours, ')
          ..write('status: $status, ')
          ..write('editedBy: $editedBy, ')
          ..write('editReason: $editReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$PosDatabase extends GeneratedDatabase {
  _$PosDatabase(QueryExecutor e) : super(e);
  $PosDatabaseManager get managers => $PosDatabaseManager(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $TicketsTable tickets = $TicketsTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $ServiceCategoriesTable serviceCategories =
      $ServiceCategoriesTable(this);
  late final $EmployeeServiceCategoriesTable employeeServiceCategories =
      $EmployeeServiceCategoriesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $TechnicianSchedulesTable technicianSchedules =
      $TechnicianSchedulesTable(this);
  late final $TimeEntriesTable timeEntries = $TimeEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    employees,
    customers,
    tickets,
    services,
    invoices,
    payments,
    appointments,
    serviceCategories,
    employeeServiceCategories,
    settings,
    technicianSchedules,
    timeEntries,
  ];
}

typedef $$EmployeesTableCreateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      required String firstName,
      required String lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> socialSecurityNumber,
      required String role,
      Value<double?> commissionRate,
      Value<double?> hourlyRate,
      required String hireDate,
      Value<bool?> isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<DateTime?> clockedInAt,
      Value<DateTime?> clockedOutAt,
      Value<bool?> isClockedIn,
      Value<String?> pin,
      Value<String?> pinSalt,
      Value<String?> pinCreatedAt,
      Value<String?> pinLastUsedAt,
    });
typedef $$EmployeesTableUpdateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> socialSecurityNumber,
      Value<String> role,
      Value<double?> commissionRate,
      Value<double?> hourlyRate,
      Value<String> hireDate,
      Value<bool?> isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<DateTime?> clockedInAt,
      Value<DateTime?> clockedOutAt,
      Value<bool?> isClockedIn,
      Value<String?> pin,
      Value<String?> pinSalt,
      Value<String?> pinCreatedAt,
      Value<String?> pinLastUsedAt,
    });

class $$EmployeesTableFilterComposer
    extends Composer<_$PosDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get socialSecurityNumber => $composableBuilder(
    column: $table.socialSecurityNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get commissionRate => $composableBuilder(
    column: $table.commissionRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hireDate => $composableBuilder(
    column: $table.hireDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clockedInAt => $composableBuilder(
    column: $table.clockedInAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clockedOutAt => $composableBuilder(
    column: $table.clockedOutAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClockedIn => $composableBuilder(
    column: $table.isClockedIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pin => $composableBuilder(
    column: $table.pin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinCreatedAt => $composableBuilder(
    column: $table.pinCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinLastUsedAt => $composableBuilder(
    column: $table.pinLastUsedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$PosDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get socialSecurityNumber => $composableBuilder(
    column: $table.socialSecurityNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get commissionRate => $composableBuilder(
    column: $table.commissionRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hireDate => $composableBuilder(
    column: $table.hireDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clockedInAt => $composableBuilder(
    column: $table.clockedInAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clockedOutAt => $composableBuilder(
    column: $table.clockedOutAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClockedIn => $composableBuilder(
    column: $table.isClockedIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pin => $composableBuilder(
    column: $table.pin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinCreatedAt => $composableBuilder(
    column: $table.pinCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinLastUsedAt => $composableBuilder(
    column: $table.pinLastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$PosDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get socialSecurityNumber => $composableBuilder(
    column: $table.socialSecurityNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<double> get commissionRate => $composableBuilder(
    column: $table.commissionRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hireDate =>
      $composableBuilder(column: $table.hireDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get clockedInAt => $composableBuilder(
    column: $table.clockedInAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get clockedOutAt => $composableBuilder(
    column: $table.clockedOutAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isClockedIn => $composableBuilder(
    column: $table.isClockedIn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pin =>
      $composableBuilder(column: $table.pin, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<String> get pinCreatedAt => $composableBuilder(
    column: $table.pinCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pinLastUsedAt => $composableBuilder(
    column: $table.pinLastUsedAt,
    builder: (column) => column,
  );
}

class $$EmployeesTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $EmployeesTable,
          Employee,
          $$EmployeesTableFilterComposer,
          $$EmployeesTableOrderingComposer,
          $$EmployeesTableAnnotationComposer,
          $$EmployeesTableCreateCompanionBuilder,
          $$EmployeesTableUpdateCompanionBuilder,
          (Employee, BaseReferences<_$PosDatabase, $EmployeesTable, Employee>),
          Employee,
          PrefetchHooks Function()
        > {
  $$EmployeesTableTableManager(_$PosDatabase db, $EmployeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> socialSecurityNumber = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<double?> commissionRate = const Value.absent(),
                Value<double?> hourlyRate = const Value.absent(),
                Value<String> hireDate = const Value.absent(),
                Value<bool?> isActive = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<DateTime?> clockedInAt = const Value.absent(),
                Value<DateTime?> clockedOutAt = const Value.absent(),
                Value<bool?> isClockedIn = const Value.absent(),
                Value<String?> pin = const Value.absent(),
                Value<String?> pinSalt = const Value.absent(),
                Value<String?> pinCreatedAt = const Value.absent(),
                Value<String?> pinLastUsedAt = const Value.absent(),
              }) => EmployeesCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                socialSecurityNumber: socialSecurityNumber,
                role: role,
                commissionRate: commissionRate,
                hourlyRate: hourlyRate,
                hireDate: hireDate,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                clockedInAt: clockedInAt,
                clockedOutAt: clockedOutAt,
                isClockedIn: isClockedIn,
                pin: pin,
                pinSalt: pinSalt,
                pinCreatedAt: pinCreatedAt,
                pinLastUsedAt: pinLastUsedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firstName,
                required String lastName,
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> socialSecurityNumber = const Value.absent(),
                required String role,
                Value<double?> commissionRate = const Value.absent(),
                Value<double?> hourlyRate = const Value.absent(),
                required String hireDate,
                Value<bool?> isActive = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<DateTime?> clockedInAt = const Value.absent(),
                Value<DateTime?> clockedOutAt = const Value.absent(),
                Value<bool?> isClockedIn = const Value.absent(),
                Value<String?> pin = const Value.absent(),
                Value<String?> pinSalt = const Value.absent(),
                Value<String?> pinCreatedAt = const Value.absent(),
                Value<String?> pinLastUsedAt = const Value.absent(),
              }) => EmployeesCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                socialSecurityNumber: socialSecurityNumber,
                role: role,
                commissionRate: commissionRate,
                hourlyRate: hourlyRate,
                hireDate: hireDate,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                clockedInAt: clockedInAt,
                clockedOutAt: clockedOutAt,
                isClockedIn: isClockedIn,
                pin: pin,
                pinSalt: pinSalt,
                pinCreatedAt: pinCreatedAt,
                pinLastUsedAt: pinLastUsedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmployeesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $EmployeesTable,
      Employee,
      $$EmployeesTableFilterComposer,
      $$EmployeesTableOrderingComposer,
      $$EmployeesTableAnnotationComposer,
      $$EmployeesTableCreateCompanionBuilder,
      $$EmployeesTableUpdateCompanionBuilder,
      (Employee, BaseReferences<_$PosDatabase, $EmployeesTable, Employee>),
      Employee,
      PrefetchHooks Function()
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String firstName,
      required String lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> dateOfBirth,
      Value<String?> gender,
      Value<String?> address,
      Value<String?> city,
      Value<String?> state,
      Value<String?> zipCode,
      Value<int?> loyaltyPoints,
      Value<String?> lastVisit,
      Value<String?> preferredTechnician,
      Value<String?> notes,
      Value<String?> allergies,
      Value<int?> emailOptIn,
      Value<int?> smsOptIn,
      Value<String?> status,
      Value<int?> isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> dateOfBirth,
      Value<String?> gender,
      Value<String?> address,
      Value<String?> city,
      Value<String?> state,
      Value<String?> zipCode,
      Value<int?> loyaltyPoints,
      Value<String?> lastVisit,
      Value<String?> preferredTechnician,
      Value<String?> notes,
      Value<String?> allergies,
      Value<int?> emailOptIn,
      Value<int?> smsOptIn,
      Value<String?> status,
      Value<int?> isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<int> rowid,
    });

class $$CustomersTableFilterComposer
    extends Composer<_$PosDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zipCode => $composableBuilder(
    column: $table.zipCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get loyaltyPoints => $composableBuilder(
    column: $table.loyaltyPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastVisit => $composableBuilder(
    column: $table.lastVisit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredTechnician => $composableBuilder(
    column: $table.preferredTechnician,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get emailOptIn => $composableBuilder(
    column: $table.emailOptIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get smsOptIn => $composableBuilder(
    column: $table.smsOptIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomersTableOrderingComposer
    extends Composer<_$PosDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zipCode => $composableBuilder(
    column: $table.zipCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loyaltyPoints => $composableBuilder(
    column: $table.loyaltyPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastVisit => $composableBuilder(
    column: $table.lastVisit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredTechnician => $composableBuilder(
    column: $table.preferredTechnician,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get emailOptIn => $composableBuilder(
    column: $table.emailOptIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get smsOptIn => $composableBuilder(
    column: $table.smsOptIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$PosDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get zipCode =>
      $composableBuilder(column: $table.zipCode, builder: (column) => column);

  GeneratedColumn<int> get loyaltyPoints => $composableBuilder(
    column: $table.loyaltyPoints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastVisit =>
      $composableBuilder(column: $table.lastVisit, builder: (column) => column);

  GeneratedColumn<String> get preferredTechnician => $composableBuilder(
    column: $table.preferredTechnician,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<int> get emailOptIn => $composableBuilder(
    column: $table.emailOptIn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get smsOptIn =>
      $composableBuilder(column: $table.smsOptIn, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, BaseReferences<_$PosDatabase, $CustomersTable, Customer>),
          Customer,
          PrefetchHooks Function()
        > {
  $$CustomersTableTableManager(_$PosDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> dateOfBirth = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> zipCode = const Value.absent(),
                Value<int?> loyaltyPoints = const Value.absent(),
                Value<String?> lastVisit = const Value.absent(),
                Value<String?> preferredTechnician = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<int?> emailOptIn = const Value.absent(),
                Value<int?> smsOptIn = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<int?> isActive = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                dateOfBirth: dateOfBirth,
                gender: gender,
                address: address,
                city: city,
                state: state,
                zipCode: zipCode,
                loyaltyPoints: loyaltyPoints,
                lastVisit: lastVisit,
                preferredTechnician: preferredTechnician,
                notes: notes,
                allergies: allergies,
                emailOptIn: emailOptIn,
                smsOptIn: smsOptIn,
                status: status,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String firstName,
                required String lastName,
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> dateOfBirth = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> zipCode = const Value.absent(),
                Value<int?> loyaltyPoints = const Value.absent(),
                Value<String?> lastVisit = const Value.absent(),
                Value<String?> preferredTechnician = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<int?> emailOptIn = const Value.absent(),
                Value<int?> smsOptIn = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<int?> isActive = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                dateOfBirth: dateOfBirth,
                gender: gender,
                address: address,
                city: city,
                state: state,
                zipCode: zipCode,
                loyaltyPoints: loyaltyPoints,
                lastVisit: lastVisit,
                preferredTechnician: preferredTechnician,
                notes: notes,
                allergies: allergies,
                emailOptIn: emailOptIn,
                smsOptIn: smsOptIn,
                status: status,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, BaseReferences<_$PosDatabase, $CustomersTable, Customer>),
      Customer,
      PrefetchHooks Function()
    >;
typedef $$TicketsTableCreateCompanionBuilder =
    TicketsCompanion Function({
      required String id,
      Value<String?> customerId,
      required int employeeId,
      required int ticketNumber,
      required String customerName,
      required List<Map<String, dynamic>> services,
      Value<int?> priority,
      Value<String?> notes,
      Value<String?> status,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      required String businessDate,
      Value<String?> checkInTime,
      Value<int?> assignedTechnicianId,
      Value<double?> totalAmount,
      Value<String?> paymentStatus,
      Value<int?> isGroupService,
      Value<int?> groupSize,
      Value<String?> appointmentId,
      Value<int> rowid,
    });
typedef $$TicketsTableUpdateCompanionBuilder =
    TicketsCompanion Function({
      Value<String> id,
      Value<String?> customerId,
      Value<int> employeeId,
      Value<int> ticketNumber,
      Value<String> customerName,
      Value<List<Map<String, dynamic>>> services,
      Value<int?> priority,
      Value<String?> notes,
      Value<String?> status,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<String> businessDate,
      Value<String?> checkInTime,
      Value<int?> assignedTechnicianId,
      Value<double?> totalAmount,
      Value<String?> paymentStatus,
      Value<int?> isGroupService,
      Value<int?> groupSize,
      Value<String?> appointmentId,
      Value<int> rowid,
    });

class $$TicketsTableFilterComposer
    extends Composer<_$PosDatabase, $TicketsTable> {
  $$TicketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ticketNumber => $composableBuilder(
    column: $table.ticketNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<Map<String, dynamic>>,
    List<Map<String, dynamic>>,
    String
  >
  get services => $composableBuilder(
    column: $table.services,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessDate => $composableBuilder(
    column: $table.businessDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assignedTechnicianId => $composableBuilder(
    column: $table.assignedTechnicianId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isGroupService => $composableBuilder(
    column: $table.isGroupService,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get groupSize => $composableBuilder(
    column: $table.groupSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TicketsTableOrderingComposer
    extends Composer<_$PosDatabase, $TicketsTable> {
  $$TicketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ticketNumber => $composableBuilder(
    column: $table.ticketNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get services => $composableBuilder(
    column: $table.services,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessDate => $composableBuilder(
    column: $table.businessDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assignedTechnicianId => $composableBuilder(
    column: $table.assignedTechnicianId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isGroupService => $composableBuilder(
    column: $table.isGroupService,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get groupSize => $composableBuilder(
    column: $table.groupSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TicketsTableAnnotationComposer
    extends Composer<_$PosDatabase, $TicketsTable> {
  $$TicketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ticketNumber => $composableBuilder(
    column: $table.ticketNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>, String>
  get services =>
      $composableBuilder(column: $table.services, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get businessDate => $composableBuilder(
    column: $table.businessDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assignedTechnicianId => $composableBuilder(
    column: $table.assignedTechnicianId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isGroupService => $composableBuilder(
    column: $table.isGroupService,
    builder: (column) => column,
  );

  GeneratedColumn<int> get groupSize =>
      $composableBuilder(column: $table.groupSize, builder: (column) => column);

  GeneratedColumn<String> get appointmentId => $composableBuilder(
    column: $table.appointmentId,
    builder: (column) => column,
  );
}

class $$TicketsTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $TicketsTable,
          Ticket,
          $$TicketsTableFilterComposer,
          $$TicketsTableOrderingComposer,
          $$TicketsTableAnnotationComposer,
          $$TicketsTableCreateCompanionBuilder,
          $$TicketsTableUpdateCompanionBuilder,
          (Ticket, BaseReferences<_$PosDatabase, $TicketsTable, Ticket>),
          Ticket,
          PrefetchHooks Function()
        > {
  $$TicketsTableTableManager(_$PosDatabase db, $TicketsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<int> ticketNumber = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<List<Map<String, dynamic>>> services =
                    const Value.absent(),
                Value<int?> priority = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<String> businessDate = const Value.absent(),
                Value<String?> checkInTime = const Value.absent(),
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<double?> totalAmount = const Value.absent(),
                Value<String?> paymentStatus = const Value.absent(),
                Value<int?> isGroupService = const Value.absent(),
                Value<int?> groupSize = const Value.absent(),
                Value<String?> appointmentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketsCompanion(
                id: id,
                customerId: customerId,
                employeeId: employeeId,
                ticketNumber: ticketNumber,
                customerName: customerName,
                services: services,
                priority: priority,
                notes: notes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                businessDate: businessDate,
                checkInTime: checkInTime,
                assignedTechnicianId: assignedTechnicianId,
                totalAmount: totalAmount,
                paymentStatus: paymentStatus,
                isGroupService: isGroupService,
                groupSize: groupSize,
                appointmentId: appointmentId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> customerId = const Value.absent(),
                required int employeeId,
                required int ticketNumber,
                required String customerName,
                required List<Map<String, dynamic>> services,
                Value<int?> priority = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                required String businessDate,
                Value<String?> checkInTime = const Value.absent(),
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<double?> totalAmount = const Value.absent(),
                Value<String?> paymentStatus = const Value.absent(),
                Value<int?> isGroupService = const Value.absent(),
                Value<int?> groupSize = const Value.absent(),
                Value<String?> appointmentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketsCompanion.insert(
                id: id,
                customerId: customerId,
                employeeId: employeeId,
                ticketNumber: ticketNumber,
                customerName: customerName,
                services: services,
                priority: priority,
                notes: notes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                businessDate: businessDate,
                checkInTime: checkInTime,
                assignedTechnicianId: assignedTechnicianId,
                totalAmount: totalAmount,
                paymentStatus: paymentStatus,
                isGroupService: isGroupService,
                groupSize: groupSize,
                appointmentId: appointmentId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TicketsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $TicketsTable,
      Ticket,
      $$TicketsTableFilterComposer,
      $$TicketsTableOrderingComposer,
      $$TicketsTableAnnotationComposer,
      $$TicketsTableCreateCompanionBuilder,
      $$TicketsTableUpdateCompanionBuilder,
      (Ticket, BaseReferences<_$PosDatabase, $TicketsTable, Ticket>),
      Ticket,
      PrefetchHooks Function()
    >;
typedef $$ServicesTableCreateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      Value<int?> categoryId,
      required int durationMinutes,
      required double basePrice,
      Value<int?> isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
    });
typedef $$ServicesTableUpdateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<int?> categoryId,
      Value<int> durationMinutes,
      Value<double> basePrice,
      Value<int?> isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
    });

class $$ServicesTableFilterComposer
    extends Composer<_$PosDatabase, $ServicesTable> {
  $$ServicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServicesTableOrderingComposer
    extends Composer<_$PosDatabase, $ServicesTable> {
  $$ServicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get basePrice => $composableBuilder(
    column: $table.basePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServicesTableAnnotationComposer
    extends Composer<_$PosDatabase, $ServicesTable> {
  $$ServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get basePrice =>
      $composableBuilder(column: $table.basePrice, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ServicesTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $ServicesTable,
          Service,
          $$ServicesTableFilterComposer,
          $$ServicesTableOrderingComposer,
          $$ServicesTableAnnotationComposer,
          $$ServicesTableCreateCompanionBuilder,
          $$ServicesTableUpdateCompanionBuilder,
          (Service, BaseReferences<_$PosDatabase, $ServicesTable, Service>),
          Service,
          PrefetchHooks Function()
        > {
  $$ServicesTableTableManager(_$PosDatabase db, $ServicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<double> basePrice = const Value.absent(),
                Value<int?> isActive = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
              }) => ServicesCompanion(
                id: id,
                name: name,
                description: description,
                categoryId: categoryId,
                durationMinutes: durationMinutes,
                basePrice: basePrice,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                required int durationMinutes,
                required double basePrice,
                Value<int?> isActive = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
              }) => ServicesCompanion.insert(
                id: id,
                name: name,
                description: description,
                categoryId: categoryId,
                durationMinutes: durationMinutes,
                basePrice: basePrice,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $ServicesTable,
      Service,
      $$ServicesTableFilterComposer,
      $$ServicesTableOrderingComposer,
      $$ServicesTableAnnotationComposer,
      $$ServicesTableCreateCompanionBuilder,
      $$ServicesTableUpdateCompanionBuilder,
      (Service, BaseReferences<_$PosDatabase, $ServicesTable, Service>),
      Service,
      PrefetchHooks Function()
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      required String id,
      required String invoiceNumber,
      required String ticketIds,
      Value<String?> customerName,
      required double subtotal,
      required double taxAmount,
      required double tipAmount,
      required double discountAmount,
      required double totalAmount,
      required String paymentMethod,
      Value<String?> discountType,
      Value<String?> discountCode,
      Value<String?> discountReason,
      Value<String?> cardType,
      Value<String?> lastFourDigits,
      Value<String?> transactionId,
      Value<String?> authorizationCode,
      required String processedAt,
      required String processedBy,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<String> id,
      Value<String> invoiceNumber,
      Value<String> ticketIds,
      Value<String?> customerName,
      Value<double> subtotal,
      Value<double> taxAmount,
      Value<double> tipAmount,
      Value<double> discountAmount,
      Value<double> totalAmount,
      Value<String> paymentMethod,
      Value<String?> discountType,
      Value<String?> discountCode,
      Value<String?> discountReason,
      Value<String?> cardType,
      Value<String?> lastFourDigits,
      Value<String?> transactionId,
      Value<String?> authorizationCode,
      Value<String> processedAt,
      Value<String> processedBy,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$InvoicesTableFilterComposer
    extends Composer<_$PosDatabase, $InvoicesTable> {
  $$InvoicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ticketIds => $composableBuilder(
    column: $table.ticketIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tipAmount => $composableBuilder(
    column: $table.tipAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountCode => $composableBuilder(
    column: $table.discountCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountReason => $composableBuilder(
    column: $table.discountReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastFourDigits => $composableBuilder(
    column: $table.lastFourDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorizationCode => $composableBuilder(
    column: $table.authorizationCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processedBy => $composableBuilder(
    column: $table.processedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvoicesTableOrderingComposer
    extends Composer<_$PosDatabase, $InvoicesTable> {
  $$InvoicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ticketIds => $composableBuilder(
    column: $table.ticketIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tipAmount => $composableBuilder(
    column: $table.tipAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountCode => $composableBuilder(
    column: $table.discountCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountReason => $composableBuilder(
    column: $table.discountReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastFourDigits => $composableBuilder(
    column: $table.lastFourDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorizationCode => $composableBuilder(
    column: $table.authorizationCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processedBy => $composableBuilder(
    column: $table.processedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvoicesTableAnnotationComposer
    extends Composer<_$PosDatabase, $InvoicesTable> {
  $$InvoicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ticketIds =>
      $composableBuilder(column: $table.ticketIds, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get tipAmount =>
      $composableBuilder(column: $table.tipAmount, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountCode => $composableBuilder(
    column: $table.discountCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountReason => $composableBuilder(
    column: $table.discountReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<String> get lastFourDigits => $composableBuilder(
    column: $table.lastFourDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorizationCode => $composableBuilder(
    column: $table.authorizationCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processedBy => $composableBuilder(
    column: $table.processedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$InvoicesTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $InvoicesTable,
          Invoice,
          $$InvoicesTableFilterComposer,
          $$InvoicesTableOrderingComposer,
          $$InvoicesTableAnnotationComposer,
          $$InvoicesTableCreateCompanionBuilder,
          $$InvoicesTableUpdateCompanionBuilder,
          (Invoice, BaseReferences<_$PosDatabase, $InvoicesTable, Invoice>),
          Invoice,
          PrefetchHooks Function()
        > {
  $$InvoicesTableTableManager(_$PosDatabase db, $InvoicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<String> ticketIds = const Value.absent(),
                Value<String?> customerName = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<double> taxAmount = const Value.absent(),
                Value<double> tipAmount = const Value.absent(),
                Value<double> discountAmount = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountCode = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<String?> lastFourDigits = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String?> authorizationCode = const Value.absent(),
                Value<String> processedAt = const Value.absent(),
                Value<String> processedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                invoiceNumber: invoiceNumber,
                ticketIds: ticketIds,
                customerName: customerName,
                subtotal: subtotal,
                taxAmount: taxAmount,
                tipAmount: tipAmount,
                discountAmount: discountAmount,
                totalAmount: totalAmount,
                paymentMethod: paymentMethod,
                discountType: discountType,
                discountCode: discountCode,
                discountReason: discountReason,
                cardType: cardType,
                lastFourDigits: lastFourDigits,
                transactionId: transactionId,
                authorizationCode: authorizationCode,
                processedAt: processedAt,
                processedBy: processedBy,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String invoiceNumber,
                required String ticketIds,
                Value<String?> customerName = const Value.absent(),
                required double subtotal,
                required double taxAmount,
                required double tipAmount,
                required double discountAmount,
                required double totalAmount,
                required String paymentMethod,
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountCode = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<String?> lastFourDigits = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String?> authorizationCode = const Value.absent(),
                required String processedAt,
                required String processedBy,
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                invoiceNumber: invoiceNumber,
                ticketIds: ticketIds,
                customerName: customerName,
                subtotal: subtotal,
                taxAmount: taxAmount,
                tipAmount: tipAmount,
                discountAmount: discountAmount,
                totalAmount: totalAmount,
                paymentMethod: paymentMethod,
                discountType: discountType,
                discountCode: discountCode,
                discountReason: discountReason,
                cardType: cardType,
                lastFourDigits: lastFourDigits,
                transactionId: transactionId,
                authorizationCode: authorizationCode,
                processedAt: processedAt,
                processedBy: processedBy,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvoicesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $InvoicesTable,
      Invoice,
      $$InvoicesTableFilterComposer,
      $$InvoicesTableOrderingComposer,
      $$InvoicesTableAnnotationComposer,
      $$InvoicesTableCreateCompanionBuilder,
      $$InvoicesTableUpdateCompanionBuilder,
      (Invoice, BaseReferences<_$PosDatabase, $InvoicesTable, Invoice>),
      Invoice,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      required String id,
      required String ticketId,
      Value<String?> invoiceId,
      required String paymentMethod,
      required double amount,
      Value<double?> tipAmount,
      Value<double?> taxAmount,
      Value<double?> discountAmount,
      Value<double?> totalAmount,
      Value<String?> discountType,
      Value<String?> discountCode,
      Value<String?> discountReason,
      Value<String?> cardType,
      Value<String?> lastFourDigits,
      Value<String?> transactionId,
      Value<String?> authorizationCode,
      Value<String?> processedAt,
      Value<String?> processedBy,
      Value<String?> notes,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<int> rowid,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<String> id,
      Value<String> ticketId,
      Value<String?> invoiceId,
      Value<String> paymentMethod,
      Value<double> amount,
      Value<double?> tipAmount,
      Value<double?> taxAmount,
      Value<double?> discountAmount,
      Value<double?> totalAmount,
      Value<String?> discountType,
      Value<String?> discountCode,
      Value<String?> discountReason,
      Value<String?> cardType,
      Value<String?> lastFourDigits,
      Value<String?> transactionId,
      Value<String?> authorizationCode,
      Value<String?> processedAt,
      Value<String?> processedBy,
      Value<String?> notes,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<int> rowid,
    });

class $$PaymentsTableFilterComposer
    extends Composer<_$PosDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ticketId => $composableBuilder(
    column: $table.ticketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceId => $composableBuilder(
    column: $table.invoiceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tipAmount => $composableBuilder(
    column: $table.tipAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountCode => $composableBuilder(
    column: $table.discountCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get discountReason => $composableBuilder(
    column: $table.discountReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastFourDigits => $composableBuilder(
    column: $table.lastFourDigits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorizationCode => $composableBuilder(
    column: $table.authorizationCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processedBy => $composableBuilder(
    column: $table.processedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$PosDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ticketId => $composableBuilder(
    column: $table.ticketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceId => $composableBuilder(
    column: $table.invoiceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tipAmount => $composableBuilder(
    column: $table.tipAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get taxAmount => $composableBuilder(
    column: $table.taxAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountCode => $composableBuilder(
    column: $table.discountCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get discountReason => $composableBuilder(
    column: $table.discountReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardType => $composableBuilder(
    column: $table.cardType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastFourDigits => $composableBuilder(
    column: $table.lastFourDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorizationCode => $composableBuilder(
    column: $table.authorizationCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processedBy => $composableBuilder(
    column: $table.processedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$PosDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ticketId =>
      $composableBuilder(column: $table.ticketId, builder: (column) => column);

  GeneratedColumn<String> get invoiceId =>
      $composableBuilder(column: $table.invoiceId, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<double> get tipAmount =>
      $composableBuilder(column: $table.tipAmount, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
    column: $table.discountAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountType => $composableBuilder(
    column: $table.discountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountCode => $composableBuilder(
    column: $table.discountCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get discountReason => $composableBuilder(
    column: $table.discountReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cardType =>
      $composableBuilder(column: $table.cardType, builder: (column) => column);

  GeneratedColumn<String> get lastFourDigits => $composableBuilder(
    column: $table.lastFourDigits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get authorizationCode => $composableBuilder(
    column: $table.authorizationCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get processedBy => $composableBuilder(
    column: $table.processedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $PaymentsTable,
          Payment,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (Payment, BaseReferences<_$PosDatabase, $PaymentsTable, Payment>),
          Payment,
          PrefetchHooks Function()
        > {
  $$PaymentsTableTableManager(_$PosDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ticketId = const Value.absent(),
                Value<String?> invoiceId = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<double?> tipAmount = const Value.absent(),
                Value<double?> taxAmount = const Value.absent(),
                Value<double?> discountAmount = const Value.absent(),
                Value<double?> totalAmount = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountCode = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<String?> lastFourDigits = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String?> authorizationCode = const Value.absent(),
                Value<String?> processedAt = const Value.absent(),
                Value<String?> processedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                ticketId: ticketId,
                invoiceId: invoiceId,
                paymentMethod: paymentMethod,
                amount: amount,
                tipAmount: tipAmount,
                taxAmount: taxAmount,
                discountAmount: discountAmount,
                totalAmount: totalAmount,
                discountType: discountType,
                discountCode: discountCode,
                discountReason: discountReason,
                cardType: cardType,
                lastFourDigits: lastFourDigits,
                transactionId: transactionId,
                authorizationCode: authorizationCode,
                processedAt: processedAt,
                processedBy: processedBy,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ticketId,
                Value<String?> invoiceId = const Value.absent(),
                required String paymentMethod,
                required double amount,
                Value<double?> tipAmount = const Value.absent(),
                Value<double?> taxAmount = const Value.absent(),
                Value<double?> discountAmount = const Value.absent(),
                Value<double?> totalAmount = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountCode = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<String?> lastFourDigits = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String?> authorizationCode = const Value.absent(),
                Value<String?> processedAt = const Value.absent(),
                Value<String?> processedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                ticketId: ticketId,
                invoiceId: invoiceId,
                paymentMethod: paymentMethod,
                amount: amount,
                tipAmount: tipAmount,
                taxAmount: taxAmount,
                discountAmount: discountAmount,
                totalAmount: totalAmount,
                discountType: discountType,
                discountCode: discountCode,
                discountReason: discountReason,
                cardType: cardType,
                lastFourDigits: lastFourDigits,
                transactionId: transactionId,
                authorizationCode: authorizationCode,
                processedAt: processedAt,
                processedBy: processedBy,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $PaymentsTable,
      Payment,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (Payment, BaseReferences<_$PosDatabase, $PaymentsTable, Payment>),
      Payment,
      PrefetchHooks Function()
    >;
typedef $$AppointmentsTableCreateCompanionBuilder =
    AppointmentsCompanion Function({
      required String id,
      required String customerId,
      required int employeeId,
      required String appointmentStartDateTime,
      required String appointmentEndDateTime,
      required List<Map<String, dynamic>> services,
      Value<String?> status,
      Value<String?> notes,
      Value<int?> isGroupBooking,
      Value<int?> groupSize,
      required String createdAt,
      required String updatedAt,
      Value<String?> lastModifiedBy,
      Value<String?> lastModifiedDevice,
      Value<String?> confirmedAt,
      Value<String?> confirmationType,
      Value<int> rowid,
    });
typedef $$AppointmentsTableUpdateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<int> employeeId,
      Value<String> appointmentStartDateTime,
      Value<String> appointmentEndDateTime,
      Value<List<Map<String, dynamic>>> services,
      Value<String?> status,
      Value<String?> notes,
      Value<int?> isGroupBooking,
      Value<int?> groupSize,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<String?> lastModifiedBy,
      Value<String?> lastModifiedDevice,
      Value<String?> confirmedAt,
      Value<String?> confirmationType,
      Value<int> rowid,
    });

class $$AppointmentsTableFilterComposer
    extends Composer<_$PosDatabase, $AppointmentsTable> {
  $$AppointmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appointmentStartDateTime => $composableBuilder(
    column: $table.appointmentStartDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appointmentEndDateTime => $composableBuilder(
    column: $table.appointmentEndDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<Map<String, dynamic>>,
    List<Map<String, dynamic>>,
    String
  >
  get services => $composableBuilder(
    column: $table.services,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isGroupBooking => $composableBuilder(
    column: $table.isGroupBooking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get groupSize => $composableBuilder(
    column: $table.groupSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModifiedBy => $composableBuilder(
    column: $table.lastModifiedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModifiedDevice => $composableBuilder(
    column: $table.lastModifiedDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmationType => $composableBuilder(
    column: $table.confirmationType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppointmentsTableOrderingComposer
    extends Composer<_$PosDatabase, $AppointmentsTable> {
  $$AppointmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appointmentStartDateTime => $composableBuilder(
    column: $table.appointmentStartDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appointmentEndDateTime => $composableBuilder(
    column: $table.appointmentEndDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get services => $composableBuilder(
    column: $table.services,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isGroupBooking => $composableBuilder(
    column: $table.isGroupBooking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get groupSize => $composableBuilder(
    column: $table.groupSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModifiedBy => $composableBuilder(
    column: $table.lastModifiedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModifiedDevice => $composableBuilder(
    column: $table.lastModifiedDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmationType => $composableBuilder(
    column: $table.confirmationType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppointmentsTableAnnotationComposer
    extends Composer<_$PosDatabase, $AppointmentsTable> {
  $$AppointmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerId => $composableBuilder(
    column: $table.customerId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appointmentStartDateTime => $composableBuilder(
    column: $table.appointmentStartDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appointmentEndDateTime => $composableBuilder(
    column: $table.appointmentEndDateTime,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Map<String, dynamic>>, String>
  get services =>
      $composableBuilder(column: $table.services, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get isGroupBooking => $composableBuilder(
    column: $table.isGroupBooking,
    builder: (column) => column,
  );

  GeneratedColumn<int> get groupSize =>
      $composableBuilder(column: $table.groupSize, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get lastModifiedBy => $composableBuilder(
    column: $table.lastModifiedBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastModifiedDevice => $composableBuilder(
    column: $table.lastModifiedDevice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confirmationType => $composableBuilder(
    column: $table.confirmationType,
    builder: (column) => column,
  );
}

class $$AppointmentsTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $AppointmentsTable,
          Appointment,
          $$AppointmentsTableFilterComposer,
          $$AppointmentsTableOrderingComposer,
          $$AppointmentsTableAnnotationComposer,
          $$AppointmentsTableCreateCompanionBuilder,
          $$AppointmentsTableUpdateCompanionBuilder,
          (
            Appointment,
            BaseReferences<_$PosDatabase, $AppointmentsTable, Appointment>,
          ),
          Appointment,
          PrefetchHooks Function()
        > {
  $$AppointmentsTableTableManager(_$PosDatabase db, $AppointmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppointmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<String> appointmentStartDateTime = const Value.absent(),
                Value<String> appointmentEndDateTime = const Value.absent(),
                Value<List<Map<String, dynamic>>> services =
                    const Value.absent(),
                Value<String?> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> isGroupBooking = const Value.absent(),
                Value<int?> groupSize = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<String?> lastModifiedBy = const Value.absent(),
                Value<String?> lastModifiedDevice = const Value.absent(),
                Value<String?> confirmedAt = const Value.absent(),
                Value<String?> confirmationType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppointmentsCompanion(
                id: id,
                customerId: customerId,
                employeeId: employeeId,
                appointmentStartDateTime: appointmentStartDateTime,
                appointmentEndDateTime: appointmentEndDateTime,
                services: services,
                status: status,
                notes: notes,
                isGroupBooking: isGroupBooking,
                groupSize: groupSize,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastModifiedBy: lastModifiedBy,
                lastModifiedDevice: lastModifiedDevice,
                confirmedAt: confirmedAt,
                confirmationType: confirmationType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                required int employeeId,
                required String appointmentStartDateTime,
                required String appointmentEndDateTime,
                required List<Map<String, dynamic>> services,
                Value<String?> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> isGroupBooking = const Value.absent(),
                Value<int?> groupSize = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<String?> lastModifiedBy = const Value.absent(),
                Value<String?> lastModifiedDevice = const Value.absent(),
                Value<String?> confirmedAt = const Value.absent(),
                Value<String?> confirmationType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppointmentsCompanion.insert(
                id: id,
                customerId: customerId,
                employeeId: employeeId,
                appointmentStartDateTime: appointmentStartDateTime,
                appointmentEndDateTime: appointmentEndDateTime,
                services: services,
                status: status,
                notes: notes,
                isGroupBooking: isGroupBooking,
                groupSize: groupSize,
                createdAt: createdAt,
                updatedAt: updatedAt,
                lastModifiedBy: lastModifiedBy,
                lastModifiedDevice: lastModifiedDevice,
                confirmedAt: confirmedAt,
                confirmationType: confirmationType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppointmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $AppointmentsTable,
      Appointment,
      $$AppointmentsTableFilterComposer,
      $$AppointmentsTableOrderingComposer,
      $$AppointmentsTableAnnotationComposer,
      $$AppointmentsTableCreateCompanionBuilder,
      $$AppointmentsTableUpdateCompanionBuilder,
      (
        Appointment,
        BaseReferences<_$PosDatabase, $AppointmentsTable, Appointment>,
      ),
      Appointment,
      PrefetchHooks Function()
    >;
typedef $$ServiceCategoriesTableCreateCompanionBuilder =
    ServiceCategoriesCompanion Function({
      Value<String?> id,
      required String name,
      Value<String?> color,
      Value<String?> icon,
      Value<int> rowid,
    });
typedef $$ServiceCategoriesTableUpdateCompanionBuilder =
    ServiceCategoriesCompanion Function({
      Value<String?> id,
      Value<String> name,
      Value<String?> color,
      Value<String?> icon,
      Value<int> rowid,
    });

class $$ServiceCategoriesTableFilterComposer
    extends Composer<_$PosDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServiceCategoriesTableOrderingComposer
    extends Composer<_$PosDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceCategoriesTableAnnotationComposer
    extends Composer<_$PosDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);
}

class $$ServiceCategoriesTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $ServiceCategoriesTable,
          ServiceCategory,
          $$ServiceCategoriesTableFilterComposer,
          $$ServiceCategoriesTableOrderingComposer,
          $$ServiceCategoriesTableAnnotationComposer,
          $$ServiceCategoriesTableCreateCompanionBuilder,
          $$ServiceCategoriesTableUpdateCompanionBuilder,
          (
            ServiceCategory,
            BaseReferences<
              _$PosDatabase,
              $ServiceCategoriesTable,
              ServiceCategory
            >,
          ),
          ServiceCategory,
          PrefetchHooks Function()
        > {
  $$ServiceCategoriesTableTableManager(
    _$PosDatabase db,
    $ServiceCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceCategoriesCompanion(
                id: id,
                name: name,
                color: color,
                icon: icon,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                required String name,
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ServiceCategoriesCompanion.insert(
                id: id,
                name: name,
                color: color,
                icon: icon,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServiceCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $ServiceCategoriesTable,
      ServiceCategory,
      $$ServiceCategoriesTableFilterComposer,
      $$ServiceCategoriesTableOrderingComposer,
      $$ServiceCategoriesTableAnnotationComposer,
      $$ServiceCategoriesTableCreateCompanionBuilder,
      $$ServiceCategoriesTableUpdateCompanionBuilder,
      (
        ServiceCategory,
        BaseReferences<_$PosDatabase, $ServiceCategoriesTable, ServiceCategory>,
      ),
      ServiceCategory,
      PrefetchHooks Function()
    >;
typedef $$EmployeeServiceCategoriesTableCreateCompanionBuilder =
    EmployeeServiceCategoriesCompanion Function({
      Value<String?> id,
      required int employeeId,
      Value<String?> categoryName,
      Value<int> rowid,
    });
typedef $$EmployeeServiceCategoriesTableUpdateCompanionBuilder =
    EmployeeServiceCategoriesCompanion Function({
      Value<String?> id,
      Value<int> employeeId,
      Value<String?> categoryName,
      Value<int> rowid,
    });

class $$EmployeeServiceCategoriesTableFilterComposer
    extends Composer<_$PosDatabase, $EmployeeServiceCategoriesTable> {
  $$EmployeeServiceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmployeeServiceCategoriesTableOrderingComposer
    extends Composer<_$PosDatabase, $EmployeeServiceCategoriesTable> {
  $$EmployeeServiceCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeeServiceCategoriesTableAnnotationComposer
    extends Composer<_$PosDatabase, $EmployeeServiceCategoriesTable> {
  $$EmployeeServiceCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );
}

class $$EmployeeServiceCategoriesTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $EmployeeServiceCategoriesTable,
          EmployeeServiceCategory,
          $$EmployeeServiceCategoriesTableFilterComposer,
          $$EmployeeServiceCategoriesTableOrderingComposer,
          $$EmployeeServiceCategoriesTableAnnotationComposer,
          $$EmployeeServiceCategoriesTableCreateCompanionBuilder,
          $$EmployeeServiceCategoriesTableUpdateCompanionBuilder,
          (
            EmployeeServiceCategory,
            BaseReferences<
              _$PosDatabase,
              $EmployeeServiceCategoriesTable,
              EmployeeServiceCategory
            >,
          ),
          EmployeeServiceCategory,
          PrefetchHooks Function()
        > {
  $$EmployeeServiceCategoriesTableTableManager(
    _$PosDatabase db,
    $EmployeeServiceCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeeServiceCategoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$EmployeeServiceCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EmployeeServiceCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeeServiceCategoriesCompanion(
                id: id,
                employeeId: employeeId,
                categoryName: categoryName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                required int employeeId,
                Value<String?> categoryName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeeServiceCategoriesCompanion.insert(
                id: id,
                employeeId: employeeId,
                categoryName: categoryName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmployeeServiceCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $EmployeeServiceCategoriesTable,
      EmployeeServiceCategory,
      $$EmployeeServiceCategoriesTableFilterComposer,
      $$EmployeeServiceCategoriesTableOrderingComposer,
      $$EmployeeServiceCategoriesTableAnnotationComposer,
      $$EmployeeServiceCategoriesTableCreateCompanionBuilder,
      $$EmployeeServiceCategoriesTableUpdateCompanionBuilder,
      (
        EmployeeServiceCategory,
        BaseReferences<
          _$PosDatabase,
          $EmployeeServiceCategoriesTable,
          EmployeeServiceCategory
        >,
      ),
      EmployeeServiceCategory,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<String?> category,
      Value<String?> dataType,
      Value<String?> description,
      Value<int?> isSystem,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<String?> category,
      Value<String?> dataType,
      Value<String?> description,
      Value<int?> isSystem,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$PosDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataType => $composableBuilder(
    column: $table.dataType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$PosDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataType => $composableBuilder(
    column: $table.dataType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$PosDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get dataType =>
      $composableBuilder(column: $table.dataType, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$PosDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$PosDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> dataType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> isSystem = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                key: key,
                value: value,
                category: category,
                dataType: dataType,
                description: description,
                isSystem: isSystem,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<String?> category = const Value.absent(),
                Value<String?> dataType = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> isSystem = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                category: category,
                dataType: dataType,
                description: description,
                isSystem: isSystem,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$PosDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$TechnicianSchedulesTableCreateCompanionBuilder =
    TechnicianSchedulesCompanion Function({
      required String id,
      required int employeeId,
      required String dayOfWeek,
      required int isScheduledOff,
      Value<int?> startTime,
      Value<int?> endTime,
      Value<String?> effectiveDate,
      Value<String?> notes,
      required int isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<int> rowid,
    });
typedef $$TechnicianSchedulesTableUpdateCompanionBuilder =
    TechnicianSchedulesCompanion Function({
      Value<String> id,
      Value<int> employeeId,
      Value<String> dayOfWeek,
      Value<int> isScheduledOff,
      Value<int?> startTime,
      Value<int?> endTime,
      Value<String?> effectiveDate,
      Value<String?> notes,
      Value<int> isActive,
      Value<String?> createdAt,
      Value<String?> updatedAt,
      Value<int> rowid,
    });

class $$TechnicianSchedulesTableFilterComposer
    extends Composer<_$PosDatabase, $TechnicianSchedulesTable> {
  $$TechnicianSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isScheduledOff => $composableBuilder(
    column: $table.isScheduledOff,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TechnicianSchedulesTableOrderingComposer
    extends Composer<_$PosDatabase, $TechnicianSchedulesTable> {
  $$TechnicianSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isScheduledOff => $composableBuilder(
    column: $table.isScheduledOff,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TechnicianSchedulesTableAnnotationComposer
    extends Composer<_$PosDatabase, $TechnicianSchedulesTable> {
  $$TechnicianSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<int> get isScheduledOff => $composableBuilder(
    column: $table.isScheduledOff,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<String> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TechnicianSchedulesTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $TechnicianSchedulesTable,
          TechnicianSchedule,
          $$TechnicianSchedulesTableFilterComposer,
          $$TechnicianSchedulesTableOrderingComposer,
          $$TechnicianSchedulesTableAnnotationComposer,
          $$TechnicianSchedulesTableCreateCompanionBuilder,
          $$TechnicianSchedulesTableUpdateCompanionBuilder,
          (
            TechnicianSchedule,
            BaseReferences<
              _$PosDatabase,
              $TechnicianSchedulesTable,
              TechnicianSchedule
            >,
          ),
          TechnicianSchedule,
          PrefetchHooks Function()
        > {
  $$TechnicianSchedulesTableTableManager(
    _$PosDatabase db,
    $TechnicianSchedulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TechnicianSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TechnicianSchedulesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$TechnicianSchedulesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<String> dayOfWeek = const Value.absent(),
                Value<int> isScheduledOff = const Value.absent(),
                Value<int?> startTime = const Value.absent(),
                Value<int?> endTime = const Value.absent(),
                Value<String?> effectiveDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TechnicianSchedulesCompanion(
                id: id,
                employeeId: employeeId,
                dayOfWeek: dayOfWeek,
                isScheduledOff: isScheduledOff,
                startTime: startTime,
                endTime: endTime,
                effectiveDate: effectiveDate,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int employeeId,
                required String dayOfWeek,
                required int isScheduledOff,
                Value<int?> startTime = const Value.absent(),
                Value<int?> endTime = const Value.absent(),
                Value<String?> effectiveDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required int isActive,
                Value<String?> createdAt = const Value.absent(),
                Value<String?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TechnicianSchedulesCompanion.insert(
                id: id,
                employeeId: employeeId,
                dayOfWeek: dayOfWeek,
                isScheduledOff: isScheduledOff,
                startTime: startTime,
                endTime: endTime,
                effectiveDate: effectiveDate,
                notes: notes,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TechnicianSchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $TechnicianSchedulesTable,
      TechnicianSchedule,
      $$TechnicianSchedulesTableFilterComposer,
      $$TechnicianSchedulesTableOrderingComposer,
      $$TechnicianSchedulesTableAnnotationComposer,
      $$TechnicianSchedulesTableCreateCompanionBuilder,
      $$TechnicianSchedulesTableUpdateCompanionBuilder,
      (
        TechnicianSchedule,
        BaseReferences<
          _$PosDatabase,
          $TechnicianSchedulesTable,
          TechnicianSchedule
        >,
      ),
      TechnicianSchedule,
      PrefetchHooks Function()
    >;
typedef $$TimeEntriesTableCreateCompanionBuilder =
    TimeEntriesCompanion Function({
      required String id,
      required int employeeId,
      required String clockIn,
      Value<String?> clockOut,
      Value<int> breakMinutes,
      Value<double?> totalHours,
      Value<String> status,
      Value<String?> editedBy,
      Value<String?> editReason,
      required String createdAt,
      required String updatedAt,
      Value<int> rowid,
    });
typedef $$TimeEntriesTableUpdateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<String> id,
      Value<int> employeeId,
      Value<String> clockIn,
      Value<String?> clockOut,
      Value<int> breakMinutes,
      Value<double?> totalHours,
      Value<String> status,
      Value<String?> editedBy,
      Value<String?> editReason,
      Value<String> createdAt,
      Value<String> updatedAt,
      Value<int> rowid,
    });

class $$TimeEntriesTableFilterComposer
    extends Composer<_$PosDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalHours => $composableBuilder(
    column: $table.totalHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editedBy => $composableBuilder(
    column: $table.editedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editReason => $composableBuilder(
    column: $table.editReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TimeEntriesTableOrderingComposer
    extends Composer<_$PosDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalHours => $composableBuilder(
    column: $table.totalHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editedBy => $composableBuilder(
    column: $table.editedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editReason => $composableBuilder(
    column: $table.editReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TimeEntriesTableAnnotationComposer
    extends Composer<_$PosDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get employeeId => $composableBuilder(
    column: $table.employeeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clockIn =>
      $composableBuilder(column: $table.clockIn, builder: (column) => column);

  GeneratedColumn<String> get clockOut =>
      $composableBuilder(column: $table.clockOut, builder: (column) => column);

  GeneratedColumn<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalHours => $composableBuilder(
    column: $table.totalHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get editedBy =>
      $composableBuilder(column: $table.editedBy, builder: (column) => column);

  GeneratedColumn<String> get editReason => $composableBuilder(
    column: $table.editReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TimeEntriesTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $TimeEntriesTable,
          TimeEntry,
          $$TimeEntriesTableFilterComposer,
          $$TimeEntriesTableOrderingComposer,
          $$TimeEntriesTableAnnotationComposer,
          $$TimeEntriesTableCreateCompanionBuilder,
          $$TimeEntriesTableUpdateCompanionBuilder,
          (
            TimeEntry,
            BaseReferences<_$PosDatabase, $TimeEntriesTable, TimeEntry>,
          ),
          TimeEntry,
          PrefetchHooks Function()
        > {
  $$TimeEntriesTableTableManager(_$PosDatabase db, $TimeEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> employeeId = const Value.absent(),
                Value<String> clockIn = const Value.absent(),
                Value<String?> clockOut = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<double?> totalHours = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> editedBy = const Value.absent(),
                Value<String?> editReason = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeEntriesCompanion(
                id: id,
                employeeId: employeeId,
                clockIn: clockIn,
                clockOut: clockOut,
                breakMinutes: breakMinutes,
                totalHours: totalHours,
                status: status,
                editedBy: editedBy,
                editReason: editReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int employeeId,
                required String clockIn,
                Value<String?> clockOut = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<double?> totalHours = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> editedBy = const Value.absent(),
                Value<String?> editReason = const Value.absent(),
                required String createdAt,
                required String updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TimeEntriesCompanion.insert(
                id: id,
                employeeId: employeeId,
                clockIn: clockIn,
                clockOut: clockOut,
                breakMinutes: breakMinutes,
                totalHours: totalHours,
                status: status,
                editedBy: editedBy,
                editReason: editReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TimeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $TimeEntriesTable,
      TimeEntry,
      $$TimeEntriesTableFilterComposer,
      $$TimeEntriesTableOrderingComposer,
      $$TimeEntriesTableAnnotationComposer,
      $$TimeEntriesTableCreateCompanionBuilder,
      $$TimeEntriesTableUpdateCompanionBuilder,
      (TimeEntry, BaseReferences<_$PosDatabase, $TimeEntriesTable, TimeEntry>),
      TimeEntry,
      PrefetchHooks Function()
    >;

class $PosDatabaseManager {
  final _$PosDatabase _db;
  $PosDatabaseManager(this._db);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db, _db.tickets);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$ServiceCategoriesTableTableManager get serviceCategories =>
      $$ServiceCategoriesTableTableManager(_db, _db.serviceCategories);
  $$EmployeeServiceCategoriesTableTableManager get employeeServiceCategories =>
      $$EmployeeServiceCategoriesTableTableManager(
        _db,
        _db.employeeServiceCategories,
      );
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$TechnicianSchedulesTableTableManager get technicianSchedules =>
      $$TechnicianSchedulesTableTableManager(_db, _db.technicianSchedules);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db, _db.timeEntries);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ServiceCategoriesTable extends ServiceCategories
    with TableInfo<$ServiceCategoriesTable, ServiceCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceCategoriesTable(this.attachedDatabase, [this._alias]);
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
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
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
  final int id;
  final String name;
  final String? color;
  final String? icon;
  const ServiceCategory({
    required this.id,
    required this.name,
    this.color,
    this.icon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
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
      id: Value(id),
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
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  ServiceCategory copyWith({
    int? id,
    String? name,
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
  }) => ServiceCategory(
    id: id ?? this.id,
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
  final Value<int> id;
  final Value<String> name;
  final Value<String?> color;
  final Value<String?> icon;
  const ServiceCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
  });
  ServiceCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ServiceCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? icon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
    });
  }

  ServiceCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? color,
    Value<String?>? icon,
  }) {
    return ServiceCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
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
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }
}

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
    requiredDuringInsert: false,
    defaultValue: const Constant('technician'),
  );
  static const VerificationMeta _commissionRateCentsMeta =
      const VerificationMeta('commissionRateCents');
  @override
  late final GeneratedColumn<int> commissionRateCents = GeneratedColumn<int>(
    'commission_rate_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hourlyRateCentsMeta = const VerificationMeta(
    'hourlyRateCents',
  );
  @override
  late final GeneratedColumn<int> hourlyRateCents = GeneratedColumn<int>(
    'hourly_rate_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hireDateMeta = const VerificationMeta(
    'hireDate',
  );
  @override
  late final GeneratedColumn<DateTime> hireDate = GeneratedColumn<DateTime>(
    'hire_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_clocked_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
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
  late final GeneratedColumn<DateTime> pinCreatedAt = GeneratedColumn<DateTime>(
    'pin_created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinLastUsedAtMeta = const VerificationMeta(
    'pinLastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> pinLastUsedAt =
      GeneratedColumn<DateTime>(
        'pin_last_used_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
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
    commissionRateCents,
    hourlyRateCents,
    hireDate,
    isActive,
    createdAt,
    updatedAt,
    clockedInAt,
    clockedOutAt,
    isClockedIn,
    pinHash,
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
    }
    if (data.containsKey('commission_rate_cents')) {
      context.handle(
        _commissionRateCentsMeta,
        commissionRateCents.isAcceptableOrUnknown(
          data['commission_rate_cents']!,
          _commissionRateCentsMeta,
        ),
      );
    }
    if (data.containsKey('hourly_rate_cents')) {
      context.handle(
        _hourlyRateCentsMeta,
        hourlyRateCents.isAcceptableOrUnknown(
          data['hourly_rate_cents']!,
          _hourlyRateCentsMeta,
        ),
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
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
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
      commissionRateCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}commission_rate_cents'],
      ),
      hourlyRateCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hourly_rate_cents'],
      ),
      hireDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}hire_date'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
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
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      ),
      pinSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_salt'],
      ),
      pinCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}pin_created_at'],
      ),
      pinLastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
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
  final int? commissionRateCents;
  final int? hourlyRateCents;
  final DateTime hireDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? clockedInAt;
  final DateTime? clockedOutAt;
  final bool isClockedIn;
  final String? pinHash;
  final String? pinSalt;
  final DateTime? pinCreatedAt;
  final DateTime? pinLastUsedAt;
  const Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.socialSecurityNumber,
    required this.role,
    this.commissionRateCents,
    this.hourlyRateCents,
    required this.hireDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.clockedInAt,
    this.clockedOutAt,
    required this.isClockedIn,
    this.pinHash,
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
    if (!nullToAbsent || commissionRateCents != null) {
      map['commission_rate_cents'] = Variable<int>(commissionRateCents);
    }
    if (!nullToAbsent || hourlyRateCents != null) {
      map['hourly_rate_cents'] = Variable<int>(hourlyRateCents);
    }
    map['hire_date'] = Variable<DateTime>(hireDate);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || clockedInAt != null) {
      map['clocked_in_at'] = Variable<DateTime>(clockedInAt);
    }
    if (!nullToAbsent || clockedOutAt != null) {
      map['clocked_out_at'] = Variable<DateTime>(clockedOutAt);
    }
    map['is_clocked_in'] = Variable<bool>(isClockedIn);
    if (!nullToAbsent || pinHash != null) {
      map['pin_hash'] = Variable<String>(pinHash);
    }
    if (!nullToAbsent || pinSalt != null) {
      map['pin_salt'] = Variable<String>(pinSalt);
    }
    if (!nullToAbsent || pinCreatedAt != null) {
      map['pin_created_at'] = Variable<DateTime>(pinCreatedAt);
    }
    if (!nullToAbsent || pinLastUsedAt != null) {
      map['pin_last_used_at'] = Variable<DateTime>(pinLastUsedAt);
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
      commissionRateCents: commissionRateCents == null && nullToAbsent
          ? const Value.absent()
          : Value(commissionRateCents),
      hourlyRateCents: hourlyRateCents == null && nullToAbsent
          ? const Value.absent()
          : Value(hourlyRateCents),
      hireDate: Value(hireDate),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      clockedInAt: clockedInAt == null && nullToAbsent
          ? const Value.absent()
          : Value(clockedInAt),
      clockedOutAt: clockedOutAt == null && nullToAbsent
          ? const Value.absent()
          : Value(clockedOutAt),
      isClockedIn: Value(isClockedIn),
      pinHash: pinHash == null && nullToAbsent
          ? const Value.absent()
          : Value(pinHash),
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
      commissionRateCents: serializer.fromJson<int?>(
        json['commissionRateCents'],
      ),
      hourlyRateCents: serializer.fromJson<int?>(json['hourlyRateCents']),
      hireDate: serializer.fromJson<DateTime>(json['hireDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      clockedInAt: serializer.fromJson<DateTime?>(json['clockedInAt']),
      clockedOutAt: serializer.fromJson<DateTime?>(json['clockedOutAt']),
      isClockedIn: serializer.fromJson<bool>(json['isClockedIn']),
      pinHash: serializer.fromJson<String?>(json['pinHash']),
      pinSalt: serializer.fromJson<String?>(json['pinSalt']),
      pinCreatedAt: serializer.fromJson<DateTime?>(json['pinCreatedAt']),
      pinLastUsedAt: serializer.fromJson<DateTime?>(json['pinLastUsedAt']),
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
      'commissionRateCents': serializer.toJson<int?>(commissionRateCents),
      'hourlyRateCents': serializer.toJson<int?>(hourlyRateCents),
      'hireDate': serializer.toJson<DateTime>(hireDate),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'clockedInAt': serializer.toJson<DateTime?>(clockedInAt),
      'clockedOutAt': serializer.toJson<DateTime?>(clockedOutAt),
      'isClockedIn': serializer.toJson<bool>(isClockedIn),
      'pinHash': serializer.toJson<String?>(pinHash),
      'pinSalt': serializer.toJson<String?>(pinSalt),
      'pinCreatedAt': serializer.toJson<DateTime?>(pinCreatedAt),
      'pinLastUsedAt': serializer.toJson<DateTime?>(pinLastUsedAt),
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
    Value<int?> commissionRateCents = const Value.absent(),
    Value<int?> hourlyRateCents = const Value.absent(),
    DateTime? hireDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> clockedInAt = const Value.absent(),
    Value<DateTime?> clockedOutAt = const Value.absent(),
    bool? isClockedIn,
    Value<String?> pinHash = const Value.absent(),
    Value<String?> pinSalt = const Value.absent(),
    Value<DateTime?> pinCreatedAt = const Value.absent(),
    Value<DateTime?> pinLastUsedAt = const Value.absent(),
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
    commissionRateCents: commissionRateCents.present
        ? commissionRateCents.value
        : this.commissionRateCents,
    hourlyRateCents: hourlyRateCents.present
        ? hourlyRateCents.value
        : this.hourlyRateCents,
    hireDate: hireDate ?? this.hireDate,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    clockedInAt: clockedInAt.present ? clockedInAt.value : this.clockedInAt,
    clockedOutAt: clockedOutAt.present ? clockedOutAt.value : this.clockedOutAt,
    isClockedIn: isClockedIn ?? this.isClockedIn,
    pinHash: pinHash.present ? pinHash.value : this.pinHash,
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
      commissionRateCents: data.commissionRateCents.present
          ? data.commissionRateCents.value
          : this.commissionRateCents,
      hourlyRateCents: data.hourlyRateCents.present
          ? data.hourlyRateCents.value
          : this.hourlyRateCents,
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
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
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
          ..write('commissionRateCents: $commissionRateCents, ')
          ..write('hourlyRateCents: $hourlyRateCents, ')
          ..write('hireDate: $hireDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clockedInAt: $clockedInAt, ')
          ..write('clockedOutAt: $clockedOutAt, ')
          ..write('isClockedIn: $isClockedIn, ')
          ..write('pinHash: $pinHash, ')
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
    commissionRateCents,
    hourlyRateCents,
    hireDate,
    isActive,
    createdAt,
    updatedAt,
    clockedInAt,
    clockedOutAt,
    isClockedIn,
    pinHash,
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
          other.commissionRateCents == this.commissionRateCents &&
          other.hourlyRateCents == this.hourlyRateCents &&
          other.hireDate == this.hireDate &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.clockedInAt == this.clockedInAt &&
          other.clockedOutAt == this.clockedOutAt &&
          other.isClockedIn == this.isClockedIn &&
          other.pinHash == this.pinHash &&
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
  final Value<int?> commissionRateCents;
  final Value<int?> hourlyRateCents;
  final Value<DateTime> hireDate;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> clockedInAt;
  final Value<DateTime?> clockedOutAt;
  final Value<bool> isClockedIn;
  final Value<String?> pinHash;
  final Value<String?> pinSalt;
  final Value<DateTime?> pinCreatedAt;
  final Value<DateTime?> pinLastUsedAt;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
    this.socialSecurityNumber = const Value.absent(),
    this.role = const Value.absent(),
    this.commissionRateCents = const Value.absent(),
    this.hourlyRateCents = const Value.absent(),
    this.hireDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clockedInAt = const Value.absent(),
    this.clockedOutAt = const Value.absent(),
    this.isClockedIn = const Value.absent(),
    this.pinHash = const Value.absent(),
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
    this.role = const Value.absent(),
    this.commissionRateCents = const Value.absent(),
    this.hourlyRateCents = const Value.absent(),
    required DateTime hireDate,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.clockedInAt = const Value.absent(),
    this.clockedOutAt = const Value.absent(),
    this.isClockedIn = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinCreatedAt = const Value.absent(),
    this.pinLastUsedAt = const Value.absent(),
  }) : firstName = Value(firstName),
       lastName = Value(lastName),
       hireDate = Value(hireDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Employee> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<String>? socialSecurityNumber,
    Expression<String>? role,
    Expression<int>? commissionRateCents,
    Expression<int>? hourlyRateCents,
    Expression<DateTime>? hireDate,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? clockedInAt,
    Expression<DateTime>? clockedOutAt,
    Expression<bool>? isClockedIn,
    Expression<String>? pinHash,
    Expression<String>? pinSalt,
    Expression<DateTime>? pinCreatedAt,
    Expression<DateTime>? pinLastUsedAt,
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
      if (commissionRateCents != null)
        'commission_rate_cents': commissionRateCents,
      if (hourlyRateCents != null) 'hourly_rate_cents': hourlyRateCents,
      if (hireDate != null) 'hire_date': hireDate,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (clockedInAt != null) 'clocked_in_at': clockedInAt,
      if (clockedOutAt != null) 'clocked_out_at': clockedOutAt,
      if (isClockedIn != null) 'is_clocked_in': isClockedIn,
      if (pinHash != null) 'pin_hash': pinHash,
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
    Value<int?>? commissionRateCents,
    Value<int?>? hourlyRateCents,
    Value<DateTime>? hireDate,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? clockedInAt,
    Value<DateTime?>? clockedOutAt,
    Value<bool>? isClockedIn,
    Value<String?>? pinHash,
    Value<String?>? pinSalt,
    Value<DateTime?>? pinCreatedAt,
    Value<DateTime?>? pinLastUsedAt,
  }) {
    return EmployeesCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      socialSecurityNumber: socialSecurityNumber ?? this.socialSecurityNumber,
      role: role ?? this.role,
      commissionRateCents: commissionRateCents ?? this.commissionRateCents,
      hourlyRateCents: hourlyRateCents ?? this.hourlyRateCents,
      hireDate: hireDate ?? this.hireDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      clockedInAt: clockedInAt ?? this.clockedInAt,
      clockedOutAt: clockedOutAt ?? this.clockedOutAt,
      isClockedIn: isClockedIn ?? this.isClockedIn,
      pinHash: pinHash ?? this.pinHash,
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
    if (commissionRateCents.present) {
      map['commission_rate_cents'] = Variable<int>(commissionRateCents.value);
    }
    if (hourlyRateCents.present) {
      map['hourly_rate_cents'] = Variable<int>(hourlyRateCents.value);
    }
    if (hireDate.present) {
      map['hire_date'] = Variable<DateTime>(hireDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (pinCreatedAt.present) {
      map['pin_created_at'] = Variable<DateTime>(pinCreatedAt.value);
    }
    if (pinLastUsedAt.present) {
      map['pin_last_used_at'] = Variable<DateTime>(pinLastUsedAt.value);
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
          ..write('commissionRateCents: $commissionRateCents, ')
          ..write('hourlyRateCents: $hourlyRateCents, ')
          ..write('hireDate: $hireDate, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clockedInAt: $clockedInAt, ')
          ..write('clockedOutAt: $clockedOutAt, ')
          ..write('isClockedIn: $isClockedIn, ')
          ..write('pinHash: $pinHash, ')
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
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastVisitMeta = const VerificationMeta(
    'lastVisit',
  );
  @override
  late final GeneratedColumn<DateTime> lastVisit = GeneratedColumn<DateTime>(
    'last_visit',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredTechnicianIdMeta =
      const VerificationMeta('preferredTechnicianId');
  @override
  late final GeneratedColumn<int> preferredTechnicianId = GeneratedColumn<int>(
    'preferred_technician_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE SET NULL',
    ),
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
  late final GeneratedColumn<bool> emailOptIn = GeneratedColumn<bool>(
    'email_opt_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("email_opt_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _smsOptInMeta = const VerificationMeta(
    'smsOptIn',
  );
  @override
  late final GeneratedColumn<bool> smsOptIn = GeneratedColumn<bool>(
    'sms_opt_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sms_opt_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
    preferredTechnicianId,
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
    if (data.containsKey('preferred_technician_id')) {
      context.handle(
        _preferredTechnicianIdMeta,
        preferredTechnicianId.isAcceptableOrUnknown(
          data['preferred_technician_id']!,
          _preferredTechnicianIdMeta,
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
        DriftSqlType.dateTime,
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
      )!,
      lastVisit: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_visit'],
      ),
      preferredTechnicianId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preferred_technician_id'],
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
        DriftSqlType.bool,
        data['${effectivePrefix}email_opt_in'],
      )!,
      smsOptIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sms_opt_in'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
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
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final int loyaltyPoints;
  final DateTime? lastVisit;
  final int? preferredTechnicianId;
  final String? notes;
  final String? allergies;
  final bool emailOptIn;
  final bool smsOptIn;
  final String status;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
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
    required this.loyaltyPoints,
    this.lastVisit,
    this.preferredTechnicianId,
    this.notes,
    this.allergies,
    required this.emailOptIn,
    required this.smsOptIn,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
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
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
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
    map['loyalty_points'] = Variable<int>(loyaltyPoints);
    if (!nullToAbsent || lastVisit != null) {
      map['last_visit'] = Variable<DateTime>(lastVisit);
    }
    if (!nullToAbsent || preferredTechnicianId != null) {
      map['preferred_technician_id'] = Variable<int>(preferredTechnicianId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || allergies != null) {
      map['allergies'] = Variable<String>(allergies);
    }
    map['email_opt_in'] = Variable<bool>(emailOptIn);
    map['sms_opt_in'] = Variable<bool>(smsOptIn);
    map['status'] = Variable<String>(status);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
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
      loyaltyPoints: Value(loyaltyPoints),
      lastVisit: lastVisit == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVisit),
      preferredTechnicianId: preferredTechnicianId == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredTechnicianId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      allergies: allergies == null && nullToAbsent
          ? const Value.absent()
          : Value(allergies),
      emailOptIn: Value(emailOptIn),
      smsOptIn: Value(smsOptIn),
      status: Value(status),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      gender: serializer.fromJson<String?>(json['gender']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      state: serializer.fromJson<String?>(json['state']),
      zipCode: serializer.fromJson<String?>(json['zipCode']),
      loyaltyPoints: serializer.fromJson<int>(json['loyaltyPoints']),
      lastVisit: serializer.fromJson<DateTime?>(json['lastVisit']),
      preferredTechnicianId: serializer.fromJson<int?>(
        json['preferredTechnicianId'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      allergies: serializer.fromJson<String?>(json['allergies']),
      emailOptIn: serializer.fromJson<bool>(json['emailOptIn']),
      smsOptIn: serializer.fromJson<bool>(json['smsOptIn']),
      status: serializer.fromJson<String>(json['status']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
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
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'gender': serializer.toJson<String?>(gender),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String?>(city),
      'state': serializer.toJson<String?>(state),
      'zipCode': serializer.toJson<String?>(zipCode),
      'loyaltyPoints': serializer.toJson<int>(loyaltyPoints),
      'lastVisit': serializer.toJson<DateTime?>(lastVisit),
      'preferredTechnicianId': serializer.toJson<int?>(preferredTechnicianId),
      'notes': serializer.toJson<String?>(notes),
      'allergies': serializer.toJson<String?>(allergies),
      'emailOptIn': serializer.toJson<bool>(emailOptIn),
      'smsOptIn': serializer.toJson<bool>(smsOptIn),
      'status': serializer.toJson<String>(status),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Customer copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<DateTime?> dateOfBirth = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> state = const Value.absent(),
    Value<String?> zipCode = const Value.absent(),
    int? loyaltyPoints,
    Value<DateTime?> lastVisit = const Value.absent(),
    Value<int?> preferredTechnicianId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    Value<String?> allergies = const Value.absent(),
    bool? emailOptIn,
    bool? smsOptIn,
    String? status,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
    lastVisit: lastVisit.present ? lastVisit.value : this.lastVisit,
    preferredTechnicianId: preferredTechnicianId.present
        ? preferredTechnicianId.value
        : this.preferredTechnicianId,
    notes: notes.present ? notes.value : this.notes,
    allergies: allergies.present ? allergies.value : this.allergies,
    emailOptIn: emailOptIn ?? this.emailOptIn,
    smsOptIn: smsOptIn ?? this.smsOptIn,
    status: status ?? this.status,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
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
      preferredTechnicianId: data.preferredTechnicianId.present
          ? data.preferredTechnicianId.value
          : this.preferredTechnicianId,
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
          ..write('preferredTechnicianId: $preferredTechnicianId, ')
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
    preferredTechnicianId,
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
          other.preferredTechnicianId == this.preferredTechnicianId &&
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
  final Value<DateTime?> dateOfBirth;
  final Value<String?> gender;
  final Value<String?> address;
  final Value<String?> city;
  final Value<String?> state;
  final Value<String?> zipCode;
  final Value<int> loyaltyPoints;
  final Value<DateTime?> lastVisit;
  final Value<int?> preferredTechnicianId;
  final Value<String?> notes;
  final Value<String?> allergies;
  final Value<bool> emailOptIn;
  final Value<bool> smsOptIn;
  final Value<String> status;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
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
    this.preferredTechnicianId = const Value.absent(),
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
    this.preferredTechnicianId = const Value.absent(),
    this.notes = const Value.absent(),
    this.allergies = const Value.absent(),
    this.emailOptIn = const Value.absent(),
    this.smsOptIn = const Value.absent(),
    this.status = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       firstName = Value(firstName),
       lastName = Value(lastName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? email,
    Expression<String>? phone,
    Expression<DateTime>? dateOfBirth,
    Expression<String>? gender,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? state,
    Expression<String>? zipCode,
    Expression<int>? loyaltyPoints,
    Expression<DateTime>? lastVisit,
    Expression<int>? preferredTechnicianId,
    Expression<String>? notes,
    Expression<String>? allergies,
    Expression<bool>? emailOptIn,
    Expression<bool>? smsOptIn,
    Expression<String>? status,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
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
      if (preferredTechnicianId != null)
        'preferred_technician_id': preferredTechnicianId,
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
    Value<DateTime?>? dateOfBirth,
    Value<String?>? gender,
    Value<String?>? address,
    Value<String?>? city,
    Value<String?>? state,
    Value<String?>? zipCode,
    Value<int>? loyaltyPoints,
    Value<DateTime?>? lastVisit,
    Value<int?>? preferredTechnicianId,
    Value<String?>? notes,
    Value<String?>? allergies,
    Value<bool>? emailOptIn,
    Value<bool>? smsOptIn,
    Value<String>? status,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
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
      preferredTechnicianId:
          preferredTechnicianId ?? this.preferredTechnicianId,
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
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
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
      map['last_visit'] = Variable<DateTime>(lastVisit.value);
    }
    if (preferredTechnicianId.present) {
      map['preferred_technician_id'] = Variable<int>(
        preferredTechnicianId.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (emailOptIn.present) {
      map['email_opt_in'] = Variable<bool>(emailOptIn.value);
    }
    if (smsOptIn.present) {
      map['sms_opt_in'] = Variable<bool>(smsOptIn.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
          ..write('preferredTechnicianId: $preferredTechnicianId, ')
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
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_categories (id) ON DELETE CASCADE',
    ),
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
  static const VerificationMeta _basePriceCentsMeta = const VerificationMeta(
    'basePriceCents',
  );
  @override
  late final GeneratedColumn<int> basePriceCents = GeneratedColumn<int>(
    'base_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    categoryId,
    durationMinutes,
    basePriceCents,
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
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
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
    if (data.containsKey('base_price_cents')) {
      context.handle(
        _basePriceCentsMeta,
        basePriceCents.isAcceptableOrUnknown(
          data['base_price_cents']!,
          _basePriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_basePriceCentsMeta);
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
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      basePriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_price_cents'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
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
  final int categoryId;
  final int durationMinutes;
  final int basePriceCents;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Service({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
    required this.durationMinutes,
    required this.basePriceCents,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['category_id'] = Variable<int>(categoryId);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['base_price_cents'] = Variable<int>(basePriceCents);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ServicesCompanion toCompanion(bool nullToAbsent) {
    return ServicesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      categoryId: Value(categoryId),
      durationMinutes: Value(durationMinutes),
      basePriceCents: Value(basePriceCents),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      categoryId: serializer.fromJson<int>(json['categoryId']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      basePriceCents: serializer.fromJson<int>(json['basePriceCents']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'categoryId': serializer.toJson<int>(categoryId),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'basePriceCents': serializer.toJson<int>(basePriceCents),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Service copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? categoryId,
    int? durationMinutes,
    int? basePriceCents,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Service(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    categoryId: categoryId ?? this.categoryId,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    basePriceCents: basePriceCents ?? this.basePriceCents,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
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
      basePriceCents: data.basePriceCents.present
          ? data.basePriceCents.value
          : this.basePriceCents,
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
          ..write('basePriceCents: $basePriceCents, ')
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
    basePriceCents,
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
          other.basePriceCents == this.basePriceCents &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ServicesCompanion extends UpdateCompanion<Service> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> categoryId;
  final Value<int> durationMinutes;
  final Value<int> basePriceCents;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ServicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.basePriceCents = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ServicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required int categoryId,
    required int durationMinutes,
    required int basePriceCents,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       categoryId = Value(categoryId),
       durationMinutes = Value(durationMinutes),
       basePriceCents = Value(basePriceCents),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Service> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? categoryId,
    Expression<int>? durationMinutes,
    Expression<int>? basePriceCents,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (categoryId != null) 'category_id': categoryId,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (basePriceCents != null) 'base_price_cents': basePriceCents,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ServicesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? categoryId,
    Value<int>? durationMinutes,
    Value<int>? basePriceCents,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ServicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      basePriceCents: basePriceCents ?? this.basePriceCents,
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
    if (basePriceCents.present) {
      map['base_price_cents'] = Variable<int>(basePriceCents.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
          ..write('basePriceCents: $basePriceCents, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES service_categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _certifiedAtMeta = const VerificationMeta(
    'certifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> certifiedAt = GeneratedColumn<DateTime>(
    'certified_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    employeeId,
    categoryId,
    certifiedAt,
    isActive,
  ];
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
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('certified_at')) {
      context.handle(
        _certifiedAtMeta,
        certifiedAt.isAcceptableOrUnknown(
          data['certified_at']!,
          _certifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {employeeId, categoryId};
  @override
  EmployeeServiceCategory map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmployeeServiceCategory(
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}employee_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      certifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}certified_at'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $EmployeeServiceCategoriesTable createAlias(String alias) {
    return $EmployeeServiceCategoriesTable(attachedDatabase, alias);
  }
}

class EmployeeServiceCategory extends DataClass
    implements Insertable<EmployeeServiceCategory> {
  final int employeeId;
  final int categoryId;
  final DateTime? certifiedAt;
  final bool isActive;
  const EmployeeServiceCategory({
    required this.employeeId,
    required this.categoryId,
    this.certifiedAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['employee_id'] = Variable<int>(employeeId);
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || certifiedAt != null) {
      map['certified_at'] = Variable<DateTime>(certifiedAt);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  EmployeeServiceCategoriesCompanion toCompanion(bool nullToAbsent) {
    return EmployeeServiceCategoriesCompanion(
      employeeId: Value(employeeId),
      categoryId: Value(categoryId),
      certifiedAt: certifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(certifiedAt),
      isActive: Value(isActive),
    );
  }

  factory EmployeeServiceCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmployeeServiceCategory(
      employeeId: serializer.fromJson<int>(json['employeeId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      certifiedAt: serializer.fromJson<DateTime?>(json['certifiedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'employeeId': serializer.toJson<int>(employeeId),
      'categoryId': serializer.toJson<int>(categoryId),
      'certifiedAt': serializer.toJson<DateTime?>(certifiedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  EmployeeServiceCategory copyWith({
    int? employeeId,
    int? categoryId,
    Value<DateTime?> certifiedAt = const Value.absent(),
    bool? isActive,
  }) => EmployeeServiceCategory(
    employeeId: employeeId ?? this.employeeId,
    categoryId: categoryId ?? this.categoryId,
    certifiedAt: certifiedAt.present ? certifiedAt.value : this.certifiedAt,
    isActive: isActive ?? this.isActive,
  );
  EmployeeServiceCategory copyWithCompanion(
    EmployeeServiceCategoriesCompanion data,
  ) {
    return EmployeeServiceCategory(
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      certifiedAt: data.certifiedAt.present
          ? data.certifiedAt.value
          : this.certifiedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeServiceCategory(')
          ..write('employeeId: $employeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('certifiedAt: $certifiedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(employeeId, categoryId, certifiedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmployeeServiceCategory &&
          other.employeeId == this.employeeId &&
          other.categoryId == this.categoryId &&
          other.certifiedAt == this.certifiedAt &&
          other.isActive == this.isActive);
}

class EmployeeServiceCategoriesCompanion
    extends UpdateCompanion<EmployeeServiceCategory> {
  final Value<int> employeeId;
  final Value<int> categoryId;
  final Value<DateTime?> certifiedAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const EmployeeServiceCategoriesCompanion({
    this.employeeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.certifiedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeeServiceCategoriesCompanion.insert({
    required int employeeId,
    required int categoryId,
    this.certifiedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : employeeId = Value(employeeId),
       categoryId = Value(categoryId);
  static Insertable<EmployeeServiceCategory> custom({
    Expression<int>? employeeId,
    Expression<int>? categoryId,
    Expression<DateTime>? certifiedAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (employeeId != null) 'employee_id': employeeId,
      if (categoryId != null) 'category_id': categoryId,
      if (certifiedAt != null) 'certified_at': certifiedAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeeServiceCategoriesCompanion copyWith({
    Value<int>? employeeId,
    Value<int>? categoryId,
    Value<DateTime?>? certifiedAt,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return EmployeeServiceCategoriesCompanion(
      employeeId: employeeId ?? this.employeeId,
      categoryId: categoryId ?? this.categoryId,
      certifiedAt: certifiedAt ?? this.certifiedAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (employeeId.present) {
      map['employee_id'] = Variable<int>(employeeId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (certifiedAt.present) {
      map['certified_at'] = Variable<DateTime>(certifiedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeeServiceCategoriesCompanion(')
          ..write('employeeId: $employeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('certifiedAt: $certifiedAt, ')
          ..write('isActive: $isActive, ')
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id) ON DELETE CASCADE',
    ),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _startDateTimeMeta = const VerificationMeta(
    'startDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> startDateTime =
      GeneratedColumn<DateTime>(
        'start_datetime',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _endDateTimeMeta = const VerificationMeta(
    'endDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> endDateTime = GeneratedColumn<DateTime>(
    'end_datetime',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<
    List<Map<String, Object?>>,
    String
  >
  services =
      GeneratedColumn<String>(
        'services',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<Map<String, Object?>>>(
        $AppointmentsTable.$converterservices,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('scheduled'),
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
  late final GeneratedColumn<bool> isGroupBooking = GeneratedColumn<bool>(
    'is_group_booking',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_group_booking" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedByMeta = const VerificationMeta(
    'lastModifiedBy',
  );
  @override
  late final GeneratedColumn<int> lastModifiedBy = GeneratedColumn<int>(
    'last_modified_by',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE SET NULL',
    ),
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
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
    'confirmed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
    startDateTime,
    endDateTime,
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
        _startDateTimeMeta,
        startDateTime.isAcceptableOrUnknown(
          data['start_datetime']!,
          _startDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startDateTimeMeta);
    }
    if (data.containsKey('end_datetime')) {
      context.handle(
        _endDateTimeMeta,
        endDateTime.isAcceptableOrUnknown(
          data['end_datetime']!,
          _endDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_endDateTimeMeta);
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
      startDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_datetime'],
      )!,
      endDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
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
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isGroupBooking: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_group_booking'],
      )!,
      groupSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_size'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      lastModifiedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_modified_by'],
      ),
      lastModifiedDevice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_modified_device'],
      ),
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
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

  static TypeConverter<List<Map<String, Object?>>, String> $converterservices =
      const ServicesJsonConverter();
}

class Appointment extends DataClass implements Insertable<Appointment> {
  final String id;
  final String customerId;
  final int employeeId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final List<Map<String, Object?>> services;
  final String status;
  final String? notes;
  final bool isGroupBooking;
  final int? groupSize;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? lastModifiedBy;
  final String? lastModifiedDevice;
  final DateTime? confirmedAt;
  final String? confirmationType;
  const Appointment({
    required this.id,
    required this.customerId,
    required this.employeeId,
    required this.startDateTime,
    required this.endDateTime,
    required this.services,
    required this.status,
    this.notes,
    required this.isGroupBooking,
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
    map['start_datetime'] = Variable<DateTime>(startDateTime);
    map['end_datetime'] = Variable<DateTime>(endDateTime);
    {
      map['services'] = Variable<String>(
        $AppointmentsTable.$converterservices.toSql(services),
      );
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_group_booking'] = Variable<bool>(isGroupBooking);
    if (!nullToAbsent || groupSize != null) {
      map['group_size'] = Variable<int>(groupSize);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastModifiedBy != null) {
      map['last_modified_by'] = Variable<int>(lastModifiedBy);
    }
    if (!nullToAbsent || lastModifiedDevice != null) {
      map['last_modified_device'] = Variable<String>(lastModifiedDevice);
    }
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt);
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
      startDateTime: Value(startDateTime),
      endDateTime: Value(endDateTime),
      services: Value(services),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      isGroupBooking: Value(isGroupBooking),
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
      startDateTime: serializer.fromJson<DateTime>(json['startDateTime']),
      endDateTime: serializer.fromJson<DateTime>(json['endDateTime']),
      services: serializer.fromJson<List<Map<String, Object?>>>(
        json['services'],
      ),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      isGroupBooking: serializer.fromJson<bool>(json['isGroupBooking']),
      groupSize: serializer.fromJson<int?>(json['groupSize']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastModifiedBy: serializer.fromJson<int?>(json['lastModifiedBy']),
      lastModifiedDevice: serializer.fromJson<String?>(
        json['lastModifiedDevice'],
      ),
      confirmedAt: serializer.fromJson<DateTime?>(json['confirmedAt']),
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
      'startDateTime': serializer.toJson<DateTime>(startDateTime),
      'endDateTime': serializer.toJson<DateTime>(endDateTime),
      'services': serializer.toJson<List<Map<String, Object?>>>(services),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'isGroupBooking': serializer.toJson<bool>(isGroupBooking),
      'groupSize': serializer.toJson<int?>(groupSize),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastModifiedBy': serializer.toJson<int?>(lastModifiedBy),
      'lastModifiedDevice': serializer.toJson<String?>(lastModifiedDevice),
      'confirmedAt': serializer.toJson<DateTime?>(confirmedAt),
      'confirmationType': serializer.toJson<String?>(confirmationType),
    };
  }

  Appointment copyWith({
    String? id,
    String? customerId,
    int? employeeId,
    DateTime? startDateTime,
    DateTime? endDateTime,
    List<Map<String, Object?>>? services,
    String? status,
    Value<String?> notes = const Value.absent(),
    bool? isGroupBooking,
    Value<int?> groupSize = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<int?> lastModifiedBy = const Value.absent(),
    Value<String?> lastModifiedDevice = const Value.absent(),
    Value<DateTime?> confirmedAt = const Value.absent(),
    Value<String?> confirmationType = const Value.absent(),
  }) => Appointment(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    employeeId: employeeId ?? this.employeeId,
    startDateTime: startDateTime ?? this.startDateTime,
    endDateTime: endDateTime ?? this.endDateTime,
    services: services ?? this.services,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    isGroupBooking: isGroupBooking ?? this.isGroupBooking,
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
      startDateTime: data.startDateTime.present
          ? data.startDateTime.value
          : this.startDateTime,
      endDateTime: data.endDateTime.present
          ? data.endDateTime.value
          : this.endDateTime,
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
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
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
    startDateTime,
    endDateTime,
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
          other.startDateTime == this.startDateTime &&
          other.endDateTime == this.endDateTime &&
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
  final Value<DateTime> startDateTime;
  final Value<DateTime> endDateTime;
  final Value<List<Map<String, Object?>>> services;
  final Value<String> status;
  final Value<String?> notes;
  final Value<bool> isGroupBooking;
  final Value<int?> groupSize;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int?> lastModifiedBy;
  final Value<String?> lastModifiedDevice;
  final Value<DateTime?> confirmedAt;
  final Value<String?> confirmationType;
  final Value<int> rowid;
  const AppointmentsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.startDateTime = const Value.absent(),
    this.endDateTime = const Value.absent(),
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
    required DateTime startDateTime,
    required DateTime endDateTime,
    required List<Map<String, Object?>> services,
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.isGroupBooking = const Value.absent(),
    this.groupSize = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastModifiedBy = const Value.absent(),
    this.lastModifiedDevice = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.confirmationType = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId),
       employeeId = Value(employeeId),
       startDateTime = Value(startDateTime),
       endDateTime = Value(endDateTime),
       services = Value(services),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Appointment> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<int>? employeeId,
    Expression<DateTime>? startDateTime,
    Expression<DateTime>? endDateTime,
    Expression<String>? services,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<bool>? isGroupBooking,
    Expression<int>? groupSize,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? lastModifiedBy,
    Expression<String>? lastModifiedDevice,
    Expression<DateTime>? confirmedAt,
    Expression<String>? confirmationType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (employeeId != null) 'employee_id': employeeId,
      if (startDateTime != null) 'start_datetime': startDateTime,
      if (endDateTime != null) 'end_datetime': endDateTime,
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
    Value<DateTime>? startDateTime,
    Value<DateTime>? endDateTime,
    Value<List<Map<String, Object?>>>? services,
    Value<String>? status,
    Value<String?>? notes,
    Value<bool>? isGroupBooking,
    Value<int?>? groupSize,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int?>? lastModifiedBy,
    Value<String?>? lastModifiedDevice,
    Value<DateTime?>? confirmedAt,
    Value<String?>? confirmationType,
    Value<int>? rowid,
  }) {
    return AppointmentsCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      employeeId: employeeId ?? this.employeeId,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
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
    if (startDateTime.present) {
      map['start_datetime'] = Variable<DateTime>(startDateTime.value);
    }
    if (endDateTime.present) {
      map['end_datetime'] = Variable<DateTime>(endDateTime.value);
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
      map['is_group_booking'] = Variable<bool>(isGroupBooking.value);
    }
    if (groupSize.present) {
      map['group_size'] = Variable<int>(groupSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastModifiedBy.present) {
      map['last_modified_by'] = Variable<int>(lastModifiedBy.value);
    }
    if (lastModifiedDevice.present) {
      map['last_modified_device'] = Variable<String>(lastModifiedDevice.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
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
          ..write('startDateTime: $startDateTime, ')
          ..write('endDateTime: $endDateTime, ')
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id) ON DELETE SET NULL',
    ),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
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
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('queued'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessDateMeta = const VerificationMeta(
    'businessDate',
  );
  @override
  late final GeneratedColumn<DateTime> businessDate = GeneratedColumn<DateTime>(
    'business_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checkInTimeMeta = const VerificationMeta(
    'checkInTime',
  );
  @override
  late final GeneratedColumn<DateTime> checkInTime = GeneratedColumn<DateTime>(
    'check_in_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _totalAmountCentsMeta = const VerificationMeta(
    'totalAmountCents',
  );
  @override
  late final GeneratedColumn<int> totalAmountCents = GeneratedColumn<int>(
    'total_amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentStatusMeta = const VerificationMeta(
    'paymentStatus',
  );
  @override
  late final GeneratedColumn<String> paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _isGroupServiceMeta = const VerificationMeta(
    'isGroupService',
  );
  @override
  late final GeneratedColumn<bool> isGroupService = GeneratedColumn<bool>(
    'is_group_service',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_group_service" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES appointments (id) ON DELETE SET NULL',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    employeeId,
    ticketNumber,
    customerName,
    priority,
    notes,
    status,
    createdAt,
    updatedAt,
    businessDate,
    checkInTime,
    assignedTechnicianId,
    totalAmountCents,
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
    if (data.containsKey('total_amount_cents')) {
      context.handle(
        _totalAmountCentsMeta,
        totalAmountCents.isAcceptableOrUnknown(
          data['total_amount_cents']!,
          _totalAmountCentsMeta,
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
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      businessDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}business_date'],
      )!,
      checkInTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check_in_time'],
      ),
      assignedTechnicianId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_technician_id'],
      ),
      totalAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount_cents'],
      ),
      paymentStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_status'],
      )!,
      isGroupService: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_group_service'],
      )!,
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
}

class Ticket extends DataClass implements Insertable<Ticket> {
  final String id;
  final String? customerId;
  final int employeeId;
  final int ticketNumber;
  final String customerName;
  final int priority;
  final String? notes;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime businessDate;
  final DateTime? checkInTime;
  final int? assignedTechnicianId;
  final int? totalAmountCents;
  final String paymentStatus;
  final bool isGroupService;
  final int? groupSize;
  final String? appointmentId;
  const Ticket({
    required this.id,
    this.customerId,
    required this.employeeId,
    required this.ticketNumber,
    required this.customerName,
    required this.priority,
    this.notes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.businessDate,
    this.checkInTime,
    this.assignedTechnicianId,
    this.totalAmountCents,
    required this.paymentStatus,
    required this.isGroupService,
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
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['business_date'] = Variable<DateTime>(businessDate);
    if (!nullToAbsent || checkInTime != null) {
      map['check_in_time'] = Variable<DateTime>(checkInTime);
    }
    if (!nullToAbsent || assignedTechnicianId != null) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId);
    }
    if (!nullToAbsent || totalAmountCents != null) {
      map['total_amount_cents'] = Variable<int>(totalAmountCents);
    }
    map['payment_status'] = Variable<String>(paymentStatus);
    map['is_group_service'] = Variable<bool>(isGroupService);
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
      priority: Value(priority),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      businessDate: Value(businessDate),
      checkInTime: checkInTime == null && nullToAbsent
          ? const Value.absent()
          : Value(checkInTime),
      assignedTechnicianId: assignedTechnicianId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedTechnicianId),
      totalAmountCents: totalAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmountCents),
      paymentStatus: Value(paymentStatus),
      isGroupService: Value(isGroupService),
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
      priority: serializer.fromJson<int>(json['priority']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      businessDate: serializer.fromJson<DateTime>(json['businessDate']),
      checkInTime: serializer.fromJson<DateTime?>(json['checkInTime']),
      assignedTechnicianId: serializer.fromJson<int?>(
        json['assignedTechnicianId'],
      ),
      totalAmountCents: serializer.fromJson<int?>(json['totalAmountCents']),
      paymentStatus: serializer.fromJson<String>(json['paymentStatus']),
      isGroupService: serializer.fromJson<bool>(json['isGroupService']),
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
      'priority': serializer.toJson<int>(priority),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'businessDate': serializer.toJson<DateTime>(businessDate),
      'checkInTime': serializer.toJson<DateTime?>(checkInTime),
      'assignedTechnicianId': serializer.toJson<int?>(assignedTechnicianId),
      'totalAmountCents': serializer.toJson<int?>(totalAmountCents),
      'paymentStatus': serializer.toJson<String>(paymentStatus),
      'isGroupService': serializer.toJson<bool>(isGroupService),
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
    int? priority,
    Value<String?> notes = const Value.absent(),
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? businessDate,
    Value<DateTime?> checkInTime = const Value.absent(),
    Value<int?> assignedTechnicianId = const Value.absent(),
    Value<int?> totalAmountCents = const Value.absent(),
    String? paymentStatus,
    bool? isGroupService,
    Value<int?> groupSize = const Value.absent(),
    Value<String?> appointmentId = const Value.absent(),
  }) => Ticket(
    id: id ?? this.id,
    customerId: customerId.present ? customerId.value : this.customerId,
    employeeId: employeeId ?? this.employeeId,
    ticketNumber: ticketNumber ?? this.ticketNumber,
    customerName: customerName ?? this.customerName,
    priority: priority ?? this.priority,
    notes: notes.present ? notes.value : this.notes,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    businessDate: businessDate ?? this.businessDate,
    checkInTime: checkInTime.present ? checkInTime.value : this.checkInTime,
    assignedTechnicianId: assignedTechnicianId.present
        ? assignedTechnicianId.value
        : this.assignedTechnicianId,
    totalAmountCents: totalAmountCents.present
        ? totalAmountCents.value
        : this.totalAmountCents,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    isGroupService: isGroupService ?? this.isGroupService,
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
      totalAmountCents: data.totalAmountCents.present
          ? data.totalAmountCents.value
          : this.totalAmountCents,
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
          ..write('priority: $priority, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('businessDate: $businessDate, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('totalAmountCents: $totalAmountCents, ')
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
    priority,
    notes,
    status,
    createdAt,
    updatedAt,
    businessDate,
    checkInTime,
    assignedTechnicianId,
    totalAmountCents,
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
          other.priority == this.priority &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.businessDate == this.businessDate &&
          other.checkInTime == this.checkInTime &&
          other.assignedTechnicianId == this.assignedTechnicianId &&
          other.totalAmountCents == this.totalAmountCents &&
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
  final Value<int> priority;
  final Value<String?> notes;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime> businessDate;
  final Value<DateTime?> checkInTime;
  final Value<int?> assignedTechnicianId;
  final Value<int?> totalAmountCents;
  final Value<String> paymentStatus;
  final Value<bool> isGroupService;
  final Value<int?> groupSize;
  final Value<String?> appointmentId;
  final Value<int> rowid;
  const TicketsCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.ticketNumber = const Value.absent(),
    this.customerName = const Value.absent(),
    this.priority = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.businessDate = const Value.absent(),
    this.checkInTime = const Value.absent(),
    this.assignedTechnicianId = const Value.absent(),
    this.totalAmountCents = const Value.absent(),
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
    this.priority = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    required DateTime businessDate,
    this.checkInTime = const Value.absent(),
    this.assignedTechnicianId = const Value.absent(),
    this.totalAmountCents = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.isGroupService = const Value.absent(),
    this.groupSize = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employeeId = Value(employeeId),
       ticketNumber = Value(ticketNumber),
       customerName = Value(customerName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       businessDate = Value(businessDate);
  static Insertable<Ticket> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<int>? employeeId,
    Expression<int>? ticketNumber,
    Expression<String>? customerName,
    Expression<int>? priority,
    Expression<String>? notes,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? businessDate,
    Expression<DateTime>? checkInTime,
    Expression<int>? assignedTechnicianId,
    Expression<int>? totalAmountCents,
    Expression<String>? paymentStatus,
    Expression<bool>? isGroupService,
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
      if (priority != null) 'priority': priority,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (businessDate != null) 'business_date': businessDate,
      if (checkInTime != null) 'check_in_time': checkInTime,
      if (assignedTechnicianId != null)
        'assigned_technician_id': assignedTechnicianId,
      if (totalAmountCents != null) 'total_amount_cents': totalAmountCents,
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
    Value<int>? priority,
    Value<String?>? notes,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime>? businessDate,
    Value<DateTime?>? checkInTime,
    Value<int?>? assignedTechnicianId,
    Value<int?>? totalAmountCents,
    Value<String>? paymentStatus,
    Value<bool>? isGroupService,
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
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      businessDate: businessDate ?? this.businessDate,
      checkInTime: checkInTime ?? this.checkInTime,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      totalAmountCents: totalAmountCents ?? this.totalAmountCents,
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
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (businessDate.present) {
      map['business_date'] = Variable<DateTime>(businessDate.value);
    }
    if (checkInTime.present) {
      map['check_in_time'] = Variable<DateTime>(checkInTime.value);
    }
    if (assignedTechnicianId.present) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId.value);
    }
    if (totalAmountCents.present) {
      map['total_amount_cents'] = Variable<int>(totalAmountCents.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(paymentStatus.value);
    }
    if (isGroupService.present) {
      map['is_group_service'] = Variable<bool>(isGroupService.value);
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
          ..write('priority: $priority, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('businessDate: $businessDate, ')
          ..write('checkInTime: $checkInTime, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('totalAmountCents: $totalAmountCents, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('isGroupService: $isGroupService, ')
          ..write('groupSize: $groupSize, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TicketServicesTable extends TicketServices
    with TableInfo<$TicketServicesTable, TicketService> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TicketServicesTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tickets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<int> serviceId = GeneratedColumn<int>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES services (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitPriceCentsMeta = const VerificationMeta(
    'unitPriceCents',
  );
  @override
  late final GeneratedColumn<int> unitPriceCents = GeneratedColumn<int>(
    'unit_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPriceCentsMeta = const VerificationMeta(
    'totalPriceCents',
  );
  @override
  late final GeneratedColumn<int> totalPriceCents = GeneratedColumn<int>(
    'total_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ticketId,
    serviceId,
    quantity,
    unitPriceCents,
    totalPriceCents,
    status,
    assignedTechnicianId,
    startedAt,
    completedAt,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ticket_services';
  @override
  VerificationContext validateIntegrity(
    Insertable<TicketService> instance, {
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
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_price_cents')) {
      context.handle(
        _unitPriceCentsMeta,
        unitPriceCents.isAcceptableOrUnknown(
          data['unit_price_cents']!,
          _unitPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceCentsMeta);
    }
    if (data.containsKey('total_price_cents')) {
      context.handle(
        _totalPriceCentsMeta,
        totalPriceCents.isAcceptableOrUnknown(
          data['total_price_cents']!,
          _totalPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalPriceCentsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
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
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TicketService map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TicketService(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ticketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ticket_id'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_cents'],
      )!,
      totalPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_price_cents'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      assignedTechnicianId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_technician_id'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TicketServicesTable createAlias(String alias) {
    return $TicketServicesTable(attachedDatabase, alias);
  }
}

class TicketService extends DataClass implements Insertable<TicketService> {
  final String id;
  final String ticketId;
  final int serviceId;
  final int quantity;
  final int unitPriceCents;
  final int totalPriceCents;
  final String status;
  final int? assignedTechnicianId;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? notes;
  final DateTime createdAt;
  const TicketService({
    required this.id,
    required this.ticketId,
    required this.serviceId,
    required this.quantity,
    required this.unitPriceCents,
    required this.totalPriceCents,
    required this.status,
    this.assignedTechnicianId,
    this.startedAt,
    this.completedAt,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ticket_id'] = Variable<String>(ticketId);
    map['service_id'] = Variable<int>(serviceId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_cents'] = Variable<int>(unitPriceCents);
    map['total_price_cents'] = Variable<int>(totalPriceCents);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || assignedTechnicianId != null) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TicketServicesCompanion toCompanion(bool nullToAbsent) {
    return TicketServicesCompanion(
      id: Value(id),
      ticketId: Value(ticketId),
      serviceId: Value(serviceId),
      quantity: Value(quantity),
      unitPriceCents: Value(unitPriceCents),
      totalPriceCents: Value(totalPriceCents),
      status: Value(status),
      assignedTechnicianId: assignedTechnicianId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedTechnicianId),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory TicketService.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TicketService(
      id: serializer.fromJson<String>(json['id']),
      ticketId: serializer.fromJson<String>(json['ticketId']),
      serviceId: serializer.fromJson<int>(json['serviceId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceCents: serializer.fromJson<int>(json['unitPriceCents']),
      totalPriceCents: serializer.fromJson<int>(json['totalPriceCents']),
      status: serializer.fromJson<String>(json['status']),
      assignedTechnicianId: serializer.fromJson<int?>(
        json['assignedTechnicianId'],
      ),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ticketId': serializer.toJson<String>(ticketId),
      'serviceId': serializer.toJson<int>(serviceId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceCents': serializer.toJson<int>(unitPriceCents),
      'totalPriceCents': serializer.toJson<int>(totalPriceCents),
      'status': serializer.toJson<String>(status),
      'assignedTechnicianId': serializer.toJson<int?>(assignedTechnicianId),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TicketService copyWith({
    String? id,
    String? ticketId,
    int? serviceId,
    int? quantity,
    int? unitPriceCents,
    int? totalPriceCents,
    String? status,
    Value<int?> assignedTechnicianId = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => TicketService(
    id: id ?? this.id,
    ticketId: ticketId ?? this.ticketId,
    serviceId: serviceId ?? this.serviceId,
    quantity: quantity ?? this.quantity,
    unitPriceCents: unitPriceCents ?? this.unitPriceCents,
    totalPriceCents: totalPriceCents ?? this.totalPriceCents,
    status: status ?? this.status,
    assignedTechnicianId: assignedTechnicianId.present
        ? assignedTechnicianId.value
        : this.assignedTechnicianId,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  TicketService copyWithCompanion(TicketServicesCompanion data) {
    return TicketService(
      id: data.id.present ? data.id.value : this.id,
      ticketId: data.ticketId.present ? data.ticketId.value : this.ticketId,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceCents: data.unitPriceCents.present
          ? data.unitPriceCents.value
          : this.unitPriceCents,
      totalPriceCents: data.totalPriceCents.present
          ? data.totalPriceCents.value
          : this.totalPriceCents,
      status: data.status.present ? data.status.value : this.status,
      assignedTechnicianId: data.assignedTechnicianId.present
          ? data.assignedTechnicianId.value
          : this.assignedTechnicianId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TicketService(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('serviceId: $serviceId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('totalPriceCents: $totalPriceCents, ')
          ..write('status: $status, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ticketId,
    serviceId,
    quantity,
    unitPriceCents,
    totalPriceCents,
    status,
    assignedTechnicianId,
    startedAt,
    completedAt,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TicketService &&
          other.id == this.id &&
          other.ticketId == this.ticketId &&
          other.serviceId == this.serviceId &&
          other.quantity == this.quantity &&
          other.unitPriceCents == this.unitPriceCents &&
          other.totalPriceCents == this.totalPriceCents &&
          other.status == this.status &&
          other.assignedTechnicianId == this.assignedTechnicianId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class TicketServicesCompanion extends UpdateCompanion<TicketService> {
  final Value<String> id;
  final Value<String> ticketId;
  final Value<int> serviceId;
  final Value<int> quantity;
  final Value<int> unitPriceCents;
  final Value<int> totalPriceCents;
  final Value<String> status;
  final Value<int?> assignedTechnicianId;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TicketServicesCompanion({
    this.id = const Value.absent(),
    this.ticketId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceCents = const Value.absent(),
    this.totalPriceCents = const Value.absent(),
    this.status = const Value.absent(),
    this.assignedTechnicianId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TicketServicesCompanion.insert({
    required String id,
    required String ticketId,
    required int serviceId,
    this.quantity = const Value.absent(),
    required int unitPriceCents,
    required int totalPriceCents,
    this.status = const Value.absent(),
    this.assignedTechnicianId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ticketId = Value(ticketId),
       serviceId = Value(serviceId),
       unitPriceCents = Value(unitPriceCents),
       totalPriceCents = Value(totalPriceCents),
       createdAt = Value(createdAt);
  static Insertable<TicketService> custom({
    Expression<String>? id,
    Expression<String>? ticketId,
    Expression<int>? serviceId,
    Expression<int>? quantity,
    Expression<int>? unitPriceCents,
    Expression<int>? totalPriceCents,
    Expression<String>? status,
    Expression<int>? assignedTechnicianId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ticketId != null) 'ticket_id': ticketId,
      if (serviceId != null) 'service_id': serviceId,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceCents != null) 'unit_price_cents': unitPriceCents,
      if (totalPriceCents != null) 'total_price_cents': totalPriceCents,
      if (status != null) 'status': status,
      if (assignedTechnicianId != null)
        'assigned_technician_id': assignedTechnicianId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TicketServicesCompanion copyWith({
    Value<String>? id,
    Value<String>? ticketId,
    Value<int>? serviceId,
    Value<int>? quantity,
    Value<int>? unitPriceCents,
    Value<int>? totalPriceCents,
    Value<String>? status,
    Value<int?>? assignedTechnicianId,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TicketServicesCompanion(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      serviceId: serviceId ?? this.serviceId,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      totalPriceCents: totalPriceCents ?? this.totalPriceCents,
      status: status ?? this.status,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
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
    if (serviceId.present) {
      map['service_id'] = Variable<int>(serviceId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceCents.present) {
      map['unit_price_cents'] = Variable<int>(unitPriceCents.value);
    }
    if (totalPriceCents.present) {
      map['total_price_cents'] = Variable<int>(totalPriceCents.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (assignedTechnicianId.present) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TicketServicesCompanion(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('serviceId: $serviceId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('totalPriceCents: $totalPriceCents, ')
          ..write('status: $status, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppointmentServicesTable extends AppointmentServices
    with TableInfo<$AppointmentServicesTable, AppointmentService> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppointmentServicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appointmentIdMeta = const VerificationMeta(
    'appointmentId',
  );
  @override
  late final GeneratedColumn<String> appointmentId = GeneratedColumn<String>(
    'appointment_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES appointments (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _serviceIdMeta = const VerificationMeta(
    'serviceId',
  );
  @override
  late final GeneratedColumn<int> serviceId = GeneratedColumn<int>(
    'service_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES services (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _unitPriceCentsMeta = const VerificationMeta(
    'unitPriceCents',
  );
  @override
  late final GeneratedColumn<int> unitPriceCents = GeneratedColumn<int>(
    'unit_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalPriceCentsMeta = const VerificationMeta(
    'totalPriceCents',
  );
  @override
  late final GeneratedColumn<int> totalPriceCents = GeneratedColumn<int>(
    'total_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('scheduled'),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE SET NULL',
    ),
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    appointmentId,
    serviceId,
    quantity,
    unitPriceCents,
    totalPriceCents,
    status,
    assignedTechnicianId,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appointment_services';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppointmentService> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('appointment_id')) {
      context.handle(
        _appointmentIdMeta,
        appointmentId.isAcceptableOrUnknown(
          data['appointment_id']!,
          _appointmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appointmentIdMeta);
    }
    if (data.containsKey('service_id')) {
      context.handle(
        _serviceIdMeta,
        serviceId.isAcceptableOrUnknown(data['service_id']!, _serviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serviceIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit_price_cents')) {
      context.handle(
        _unitPriceCentsMeta,
        unitPriceCents.isAcceptableOrUnknown(
          data['unit_price_cents']!,
          _unitPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceCentsMeta);
    }
    if (data.containsKey('total_price_cents')) {
      context.handle(
        _totalPriceCentsMeta,
        totalPriceCents.isAcceptableOrUnknown(
          data['total_price_cents']!,
          _totalPriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalPriceCentsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppointmentService map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppointmentService(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      appointmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appointment_id'],
      )!,
      serviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_cents'],
      )!,
      totalPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_price_cents'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      assignedTechnicianId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assigned_technician_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppointmentServicesTable createAlias(String alias) {
    return $AppointmentServicesTable(attachedDatabase, alias);
  }
}

class AppointmentService extends DataClass
    implements Insertable<AppointmentService> {
  final String id;
  final String appointmentId;
  final int serviceId;
  final int quantity;
  final int unitPriceCents;
  final int totalPriceCents;
  final String status;
  final int? assignedTechnicianId;
  final String? notes;
  final DateTime createdAt;
  const AppointmentService({
    required this.id,
    required this.appointmentId,
    required this.serviceId,
    required this.quantity,
    required this.unitPriceCents,
    required this.totalPriceCents,
    required this.status,
    this.assignedTechnicianId,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['appointment_id'] = Variable<String>(appointmentId);
    map['service_id'] = Variable<int>(serviceId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_cents'] = Variable<int>(unitPriceCents);
    map['total_price_cents'] = Variable<int>(totalPriceCents);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || assignedTechnicianId != null) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AppointmentServicesCompanion toCompanion(bool nullToAbsent) {
    return AppointmentServicesCompanion(
      id: Value(id),
      appointmentId: Value(appointmentId),
      serviceId: Value(serviceId),
      quantity: Value(quantity),
      unitPriceCents: Value(unitPriceCents),
      totalPriceCents: Value(totalPriceCents),
      status: Value(status),
      assignedTechnicianId: assignedTechnicianId == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedTechnicianId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory AppointmentService.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppointmentService(
      id: serializer.fromJson<String>(json['id']),
      appointmentId: serializer.fromJson<String>(json['appointmentId']),
      serviceId: serializer.fromJson<int>(json['serviceId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceCents: serializer.fromJson<int>(json['unitPriceCents']),
      totalPriceCents: serializer.fromJson<int>(json['totalPriceCents']),
      status: serializer.fromJson<String>(json['status']),
      assignedTechnicianId: serializer.fromJson<int?>(
        json['assignedTechnicianId'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'appointmentId': serializer.toJson<String>(appointmentId),
      'serviceId': serializer.toJson<int>(serviceId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceCents': serializer.toJson<int>(unitPriceCents),
      'totalPriceCents': serializer.toJson<int>(totalPriceCents),
      'status': serializer.toJson<String>(status),
      'assignedTechnicianId': serializer.toJson<int?>(assignedTechnicianId),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AppointmentService copyWith({
    String? id,
    String? appointmentId,
    int? serviceId,
    int? quantity,
    int? unitPriceCents,
    int? totalPriceCents,
    String? status,
    Value<int?> assignedTechnicianId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => AppointmentService(
    id: id ?? this.id,
    appointmentId: appointmentId ?? this.appointmentId,
    serviceId: serviceId ?? this.serviceId,
    quantity: quantity ?? this.quantity,
    unitPriceCents: unitPriceCents ?? this.unitPriceCents,
    totalPriceCents: totalPriceCents ?? this.totalPriceCents,
    status: status ?? this.status,
    assignedTechnicianId: assignedTechnicianId.present
        ? assignedTechnicianId.value
        : this.assignedTechnicianId,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  AppointmentService copyWithCompanion(AppointmentServicesCompanion data) {
    return AppointmentService(
      id: data.id.present ? data.id.value : this.id,
      appointmentId: data.appointmentId.present
          ? data.appointmentId.value
          : this.appointmentId,
      serviceId: data.serviceId.present ? data.serviceId.value : this.serviceId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceCents: data.unitPriceCents.present
          ? data.unitPriceCents.value
          : this.unitPriceCents,
      totalPriceCents: data.totalPriceCents.present
          ? data.totalPriceCents.value
          : this.totalPriceCents,
      status: data.status.present ? data.status.value : this.status,
      assignedTechnicianId: data.assignedTechnicianId.present
          ? data.assignedTechnicianId.value
          : this.assignedTechnicianId,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentService(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('serviceId: $serviceId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('totalPriceCents: $totalPriceCents, ')
          ..write('status: $status, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    appointmentId,
    serviceId,
    quantity,
    unitPriceCents,
    totalPriceCents,
    status,
    assignedTechnicianId,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentService &&
          other.id == this.id &&
          other.appointmentId == this.appointmentId &&
          other.serviceId == this.serviceId &&
          other.quantity == this.quantity &&
          other.unitPriceCents == this.unitPriceCents &&
          other.totalPriceCents == this.totalPriceCents &&
          other.status == this.status &&
          other.assignedTechnicianId == this.assignedTechnicianId &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class AppointmentServicesCompanion extends UpdateCompanion<AppointmentService> {
  final Value<String> id;
  final Value<String> appointmentId;
  final Value<int> serviceId;
  final Value<int> quantity;
  final Value<int> unitPriceCents;
  final Value<int> totalPriceCents;
  final Value<String> status;
  final Value<int?> assignedTechnicianId;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AppointmentServicesCompanion({
    this.id = const Value.absent(),
    this.appointmentId = const Value.absent(),
    this.serviceId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceCents = const Value.absent(),
    this.totalPriceCents = const Value.absent(),
    this.status = const Value.absent(),
    this.assignedTechnicianId = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppointmentServicesCompanion.insert({
    required String id,
    required String appointmentId,
    required int serviceId,
    this.quantity = const Value.absent(),
    required int unitPriceCents,
    required int totalPriceCents,
    this.status = const Value.absent(),
    this.assignedTechnicianId = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       appointmentId = Value(appointmentId),
       serviceId = Value(serviceId),
       unitPriceCents = Value(unitPriceCents),
       totalPriceCents = Value(totalPriceCents),
       createdAt = Value(createdAt);
  static Insertable<AppointmentService> custom({
    Expression<String>? id,
    Expression<String>? appointmentId,
    Expression<int>? serviceId,
    Expression<int>? quantity,
    Expression<int>? unitPriceCents,
    Expression<int>? totalPriceCents,
    Expression<String>? status,
    Expression<int>? assignedTechnicianId,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (appointmentId != null) 'appointment_id': appointmentId,
      if (serviceId != null) 'service_id': serviceId,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceCents != null) 'unit_price_cents': unitPriceCents,
      if (totalPriceCents != null) 'total_price_cents': totalPriceCents,
      if (status != null) 'status': status,
      if (assignedTechnicianId != null)
        'assigned_technician_id': assignedTechnicianId,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppointmentServicesCompanion copyWith({
    Value<String>? id,
    Value<String>? appointmentId,
    Value<int>? serviceId,
    Value<int>? quantity,
    Value<int>? unitPriceCents,
    Value<int>? totalPriceCents,
    Value<String>? status,
    Value<int?>? assignedTechnicianId,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AppointmentServicesCompanion(
      id: id ?? this.id,
      appointmentId: appointmentId ?? this.appointmentId,
      serviceId: serviceId ?? this.serviceId,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      totalPriceCents: totalPriceCents ?? this.totalPriceCents,
      status: status ?? this.status,
      assignedTechnicianId: assignedTechnicianId ?? this.assignedTechnicianId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (appointmentId.present) {
      map['appointment_id'] = Variable<String>(appointmentId.value);
    }
    if (serviceId.present) {
      map['service_id'] = Variable<int>(serviceId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceCents.present) {
      map['unit_price_cents'] = Variable<int>(unitPriceCents.value);
    }
    if (totalPriceCents.present) {
      map['total_price_cents'] = Variable<int>(totalPriceCents.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (assignedTechnicianId.present) {
      map['assigned_technician_id'] = Variable<int>(assignedTechnicianId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppointmentServicesCompanion(')
          ..write('id: $id, ')
          ..write('appointmentId: $appointmentId, ')
          ..write('serviceId: $serviceId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceCents: $unitPriceCents, ')
          ..write('totalPriceCents: $totalPriceCents, ')
          ..write('status: $status, ')
          ..write('assignedTechnicianId: $assignedTechnicianId, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
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
  static const VerificationMeta _subtotalCentsMeta = const VerificationMeta(
    'subtotalCents',
  );
  @override
  late final GeneratedColumn<int> subtotalCents = GeneratedColumn<int>(
    'subtotal_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxAmountCentsMeta = const VerificationMeta(
    'taxAmountCents',
  );
  @override
  late final GeneratedColumn<int> taxAmountCents = GeneratedColumn<int>(
    'tax_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipAmountCentsMeta = const VerificationMeta(
    'tipAmountCents',
  );
  @override
  late final GeneratedColumn<int> tipAmountCents = GeneratedColumn<int>(
    'tip_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountAmountCentsMeta =
      const VerificationMeta('discountAmountCents');
  @override
  late final GeneratedColumn<int> discountAmountCents = GeneratedColumn<int>(
    'discount_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountCentsMeta = const VerificationMeta(
    'totalAmountCents',
  );
  @override
  late final GeneratedColumn<int> totalAmountCents = GeneratedColumn<int>(
    'total_amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
    'processed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processedByMeta = const VerificationMeta(
    'processedBy',
  );
  @override
  late final GeneratedColumn<int> processedBy = GeneratedColumn<int>(
    'processed_by',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNumber,
    customerName,
    subtotalCents,
    taxAmountCents,
    tipAmountCents,
    discountAmountCents,
    totalAmountCents,
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
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    }
    if (data.containsKey('subtotal_cents')) {
      context.handle(
        _subtotalCentsMeta,
        subtotalCents.isAcceptableOrUnknown(
          data['subtotal_cents']!,
          _subtotalCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subtotalCentsMeta);
    }
    if (data.containsKey('tax_amount_cents')) {
      context.handle(
        _taxAmountCentsMeta,
        taxAmountCents.isAcceptableOrUnknown(
          data['tax_amount_cents']!,
          _taxAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taxAmountCentsMeta);
    }
    if (data.containsKey('tip_amount_cents')) {
      context.handle(
        _tipAmountCentsMeta,
        tipAmountCents.isAcceptableOrUnknown(
          data['tip_amount_cents']!,
          _tipAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tipAmountCentsMeta);
    }
    if (data.containsKey('discount_amount_cents')) {
      context.handle(
        _discountAmountCentsMeta,
        discountAmountCents.isAcceptableOrUnknown(
          data['discount_amount_cents']!,
          _discountAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_discountAmountCentsMeta);
    }
    if (data.containsKey('total_amount_cents')) {
      context.handle(
        _totalAmountCentsMeta,
        totalAmountCents.isAcceptableOrUnknown(
          data['total_amount_cents']!,
          _totalAmountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountCentsMeta);
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
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      ),
      subtotalCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal_cents'],
      )!,
      taxAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_amount_cents'],
      )!,
      tipAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tip_amount_cents'],
      )!,
      discountAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_amount_cents'],
      )!,
      totalAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount_cents'],
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
        DriftSqlType.dateTime,
        data['${effectivePrefix}processed_at'],
      )!,
      processedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processed_by'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
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
  final String? customerName;
  final int subtotalCents;
  final int taxAmountCents;
  final int tipAmountCents;
  final int discountAmountCents;
  final int totalAmountCents;
  final String paymentMethod;
  final String? discountType;
  final String? discountCode;
  final String? discountReason;
  final String? cardType;
  final String? lastFourDigits;
  final String? transactionId;
  final String? authorizationCode;
  final DateTime processedAt;
  final int processedBy;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Invoice({
    required this.id,
    required this.invoiceNumber,
    this.customerName,
    required this.subtotalCents,
    required this.taxAmountCents,
    required this.tipAmountCents,
    required this.discountAmountCents,
    required this.totalAmountCents,
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
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    map['subtotal_cents'] = Variable<int>(subtotalCents);
    map['tax_amount_cents'] = Variable<int>(taxAmountCents);
    map['tip_amount_cents'] = Variable<int>(tipAmountCents);
    map['discount_amount_cents'] = Variable<int>(discountAmountCents);
    map['total_amount_cents'] = Variable<int>(totalAmountCents);
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
    map['processed_at'] = Variable<DateTime>(processedAt);
    map['processed_by'] = Variable<int>(processedBy);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  InvoicesCompanion toCompanion(bool nullToAbsent) {
    return InvoicesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      subtotalCents: Value(subtotalCents),
      taxAmountCents: Value(taxAmountCents),
      tipAmountCents: Value(tipAmountCents),
      discountAmountCents: Value(discountAmountCents),
      totalAmountCents: Value(totalAmountCents),
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
      customerName: serializer.fromJson<String?>(json['customerName']),
      subtotalCents: serializer.fromJson<int>(json['subtotalCents']),
      taxAmountCents: serializer.fromJson<int>(json['taxAmountCents']),
      tipAmountCents: serializer.fromJson<int>(json['tipAmountCents']),
      discountAmountCents: serializer.fromJson<int>(
        json['discountAmountCents'],
      ),
      totalAmountCents: serializer.fromJson<int>(json['totalAmountCents']),
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
      processedAt: serializer.fromJson<DateTime>(json['processedAt']),
      processedBy: serializer.fromJson<int>(json['processedBy']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'customerName': serializer.toJson<String?>(customerName),
      'subtotalCents': serializer.toJson<int>(subtotalCents),
      'taxAmountCents': serializer.toJson<int>(taxAmountCents),
      'tipAmountCents': serializer.toJson<int>(tipAmountCents),
      'discountAmountCents': serializer.toJson<int>(discountAmountCents),
      'totalAmountCents': serializer.toJson<int>(totalAmountCents),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'discountType': serializer.toJson<String?>(discountType),
      'discountCode': serializer.toJson<String?>(discountCode),
      'discountReason': serializer.toJson<String?>(discountReason),
      'cardType': serializer.toJson<String?>(cardType),
      'lastFourDigits': serializer.toJson<String?>(lastFourDigits),
      'transactionId': serializer.toJson<String?>(transactionId),
      'authorizationCode': serializer.toJson<String?>(authorizationCode),
      'processedAt': serializer.toJson<DateTime>(processedAt),
      'processedBy': serializer.toJson<int>(processedBy),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Invoice copyWith({
    String? id,
    String? invoiceNumber,
    Value<String?> customerName = const Value.absent(),
    int? subtotalCents,
    int? taxAmountCents,
    int? tipAmountCents,
    int? discountAmountCents,
    int? totalAmountCents,
    String? paymentMethod,
    Value<String?> discountType = const Value.absent(),
    Value<String?> discountCode = const Value.absent(),
    Value<String?> discountReason = const Value.absent(),
    Value<String?> cardType = const Value.absent(),
    Value<String?> lastFourDigits = const Value.absent(),
    Value<String?> transactionId = const Value.absent(),
    Value<String?> authorizationCode = const Value.absent(),
    DateTime? processedAt,
    int? processedBy,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Invoice(
    id: id ?? this.id,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    customerName: customerName.present ? customerName.value : this.customerName,
    subtotalCents: subtotalCents ?? this.subtotalCents,
    taxAmountCents: taxAmountCents ?? this.taxAmountCents,
    tipAmountCents: tipAmountCents ?? this.tipAmountCents,
    discountAmountCents: discountAmountCents ?? this.discountAmountCents,
    totalAmountCents: totalAmountCents ?? this.totalAmountCents,
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
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      subtotalCents: data.subtotalCents.present
          ? data.subtotalCents.value
          : this.subtotalCents,
      taxAmountCents: data.taxAmountCents.present
          ? data.taxAmountCents.value
          : this.taxAmountCents,
      tipAmountCents: data.tipAmountCents.present
          ? data.tipAmountCents.value
          : this.tipAmountCents,
      discountAmountCents: data.discountAmountCents.present
          ? data.discountAmountCents.value
          : this.discountAmountCents,
      totalAmountCents: data.totalAmountCents.present
          ? data.totalAmountCents.value
          : this.totalAmountCents,
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
          ..write('customerName: $customerName, ')
          ..write('subtotalCents: $subtotalCents, ')
          ..write('taxAmountCents: $taxAmountCents, ')
          ..write('tipAmountCents: $tipAmountCents, ')
          ..write('discountAmountCents: $discountAmountCents, ')
          ..write('totalAmountCents: $totalAmountCents, ')
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
    customerName,
    subtotalCents,
    taxAmountCents,
    tipAmountCents,
    discountAmountCents,
    totalAmountCents,
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
          other.customerName == this.customerName &&
          other.subtotalCents == this.subtotalCents &&
          other.taxAmountCents == this.taxAmountCents &&
          other.tipAmountCents == this.tipAmountCents &&
          other.discountAmountCents == this.discountAmountCents &&
          other.totalAmountCents == this.totalAmountCents &&
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
  final Value<String?> customerName;
  final Value<int> subtotalCents;
  final Value<int> taxAmountCents;
  final Value<int> tipAmountCents;
  final Value<int> discountAmountCents;
  final Value<int> totalAmountCents;
  final Value<String> paymentMethod;
  final Value<String?> discountType;
  final Value<String?> discountCode;
  final Value<String?> discountReason;
  final Value<String?> cardType;
  final Value<String?> lastFourDigits;
  final Value<String?> transactionId;
  final Value<String?> authorizationCode;
  final Value<DateTime> processedAt;
  final Value<int> processedBy;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const InvoicesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.customerName = const Value.absent(),
    this.subtotalCents = const Value.absent(),
    this.taxAmountCents = const Value.absent(),
    this.tipAmountCents = const Value.absent(),
    this.discountAmountCents = const Value.absent(),
    this.totalAmountCents = const Value.absent(),
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
    this.customerName = const Value.absent(),
    required int subtotalCents,
    required int taxAmountCents,
    required int tipAmountCents,
    required int discountAmountCents,
    required int totalAmountCents,
    required String paymentMethod,
    this.discountType = const Value.absent(),
    this.discountCode = const Value.absent(),
    this.discountReason = const Value.absent(),
    this.cardType = const Value.absent(),
    this.lastFourDigits = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.authorizationCode = const Value.absent(),
    required DateTime processedAt,
    required int processedBy,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       invoiceNumber = Value(invoiceNumber),
       subtotalCents = Value(subtotalCents),
       taxAmountCents = Value(taxAmountCents),
       tipAmountCents = Value(tipAmountCents),
       discountAmountCents = Value(discountAmountCents),
       totalAmountCents = Value(totalAmountCents),
       paymentMethod = Value(paymentMethod),
       processedAt = Value(processedAt),
       processedBy = Value(processedBy),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Invoice> custom({
    Expression<String>? id,
    Expression<String>? invoiceNumber,
    Expression<String>? customerName,
    Expression<int>? subtotalCents,
    Expression<int>? taxAmountCents,
    Expression<int>? tipAmountCents,
    Expression<int>? discountAmountCents,
    Expression<int>? totalAmountCents,
    Expression<String>? paymentMethod,
    Expression<String>? discountType,
    Expression<String>? discountCode,
    Expression<String>? discountReason,
    Expression<String>? cardType,
    Expression<String>? lastFourDigits,
    Expression<String>? transactionId,
    Expression<String>? authorizationCode,
    Expression<DateTime>? processedAt,
    Expression<int>? processedBy,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (customerName != null) 'customer_name': customerName,
      if (subtotalCents != null) 'subtotal_cents': subtotalCents,
      if (taxAmountCents != null) 'tax_amount_cents': taxAmountCents,
      if (tipAmountCents != null) 'tip_amount_cents': tipAmountCents,
      if (discountAmountCents != null)
        'discount_amount_cents': discountAmountCents,
      if (totalAmountCents != null) 'total_amount_cents': totalAmountCents,
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
    Value<String?>? customerName,
    Value<int>? subtotalCents,
    Value<int>? taxAmountCents,
    Value<int>? tipAmountCents,
    Value<int>? discountAmountCents,
    Value<int>? totalAmountCents,
    Value<String>? paymentMethod,
    Value<String?>? discountType,
    Value<String?>? discountCode,
    Value<String?>? discountReason,
    Value<String?>? cardType,
    Value<String?>? lastFourDigits,
    Value<String?>? transactionId,
    Value<String?>? authorizationCode,
    Value<DateTime>? processedAt,
    Value<int>? processedBy,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return InvoicesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerName: customerName ?? this.customerName,
      subtotalCents: subtotalCents ?? this.subtotalCents,
      taxAmountCents: taxAmountCents ?? this.taxAmountCents,
      tipAmountCents: tipAmountCents ?? this.tipAmountCents,
      discountAmountCents: discountAmountCents ?? this.discountAmountCents,
      totalAmountCents: totalAmountCents ?? this.totalAmountCents,
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
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (subtotalCents.present) {
      map['subtotal_cents'] = Variable<int>(subtotalCents.value);
    }
    if (taxAmountCents.present) {
      map['tax_amount_cents'] = Variable<int>(taxAmountCents.value);
    }
    if (tipAmountCents.present) {
      map['tip_amount_cents'] = Variable<int>(tipAmountCents.value);
    }
    if (discountAmountCents.present) {
      map['discount_amount_cents'] = Variable<int>(discountAmountCents.value);
    }
    if (totalAmountCents.present) {
      map['total_amount_cents'] = Variable<int>(totalAmountCents.value);
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
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (processedBy.present) {
      map['processed_by'] = Variable<int>(processedBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
          ..write('customerName: $customerName, ')
          ..write('subtotalCents: $subtotalCents, ')
          ..write('taxAmountCents: $taxAmountCents, ')
          ..write('tipAmountCents: $tipAmountCents, ')
          ..write('discountAmountCents: $discountAmountCents, ')
          ..write('totalAmountCents: $totalAmountCents, ')
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

class $InvoiceTicketsTable extends InvoiceTickets
    with TableInfo<$InvoiceTicketsTable, InvoiceTicket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceTicketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _invoiceIdMeta = const VerificationMeta(
    'invoiceId',
  );
  @override
  late final GeneratedColumn<String> invoiceId = GeneratedColumn<String>(
    'invoice_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id) ON DELETE CASCADE',
    ),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tickets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _allocatedAmountCentsMeta =
      const VerificationMeta('allocatedAmountCents');
  @override
  late final GeneratedColumn<int> allocatedAmountCents = GeneratedColumn<int>(
    'allocated_amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    invoiceId,
    ticketId,
    allocatedAmountCents,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_tickets';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceTicket> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('invoice_id')) {
      context.handle(
        _invoiceIdMeta,
        invoiceId.isAcceptableOrUnknown(data['invoice_id']!, _invoiceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_invoiceIdMeta);
    }
    if (data.containsKey('ticket_id')) {
      context.handle(
        _ticketIdMeta,
        ticketId.isAcceptableOrUnknown(data['ticket_id']!, _ticketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ticketIdMeta);
    }
    if (data.containsKey('allocated_amount_cents')) {
      context.handle(
        _allocatedAmountCentsMeta,
        allocatedAmountCents.isAcceptableOrUnknown(
          data['allocated_amount_cents']!,
          _allocatedAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {invoiceId, ticketId};
  @override
  InvoiceTicket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceTicket(
      invoiceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_id'],
      )!,
      ticketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ticket_id'],
      )!,
      allocatedAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allocated_amount_cents'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $InvoiceTicketsTable createAlias(String alias) {
    return $InvoiceTicketsTable(attachedDatabase, alias);
  }
}

class InvoiceTicket extends DataClass implements Insertable<InvoiceTicket> {
  final String invoiceId;
  final String ticketId;
  final int? allocatedAmountCents;
  final DateTime addedAt;
  const InvoiceTicket({
    required this.invoiceId,
    required this.ticketId,
    this.allocatedAmountCents,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['invoice_id'] = Variable<String>(invoiceId);
    map['ticket_id'] = Variable<String>(ticketId);
    if (!nullToAbsent || allocatedAmountCents != null) {
      map['allocated_amount_cents'] = Variable<int>(allocatedAmountCents);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  InvoiceTicketsCompanion toCompanion(bool nullToAbsent) {
    return InvoiceTicketsCompanion(
      invoiceId: Value(invoiceId),
      ticketId: Value(ticketId),
      allocatedAmountCents: allocatedAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(allocatedAmountCents),
      addedAt: Value(addedAt),
    );
  }

  factory InvoiceTicket.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceTicket(
      invoiceId: serializer.fromJson<String>(json['invoiceId']),
      ticketId: serializer.fromJson<String>(json['ticketId']),
      allocatedAmountCents: serializer.fromJson<int?>(
        json['allocatedAmountCents'],
      ),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'invoiceId': serializer.toJson<String>(invoiceId),
      'ticketId': serializer.toJson<String>(ticketId),
      'allocatedAmountCents': serializer.toJson<int?>(allocatedAmountCents),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  InvoiceTicket copyWith({
    String? invoiceId,
    String? ticketId,
    Value<int?> allocatedAmountCents = const Value.absent(),
    DateTime? addedAt,
  }) => InvoiceTicket(
    invoiceId: invoiceId ?? this.invoiceId,
    ticketId: ticketId ?? this.ticketId,
    allocatedAmountCents: allocatedAmountCents.present
        ? allocatedAmountCents.value
        : this.allocatedAmountCents,
    addedAt: addedAt ?? this.addedAt,
  );
  InvoiceTicket copyWithCompanion(InvoiceTicketsCompanion data) {
    return InvoiceTicket(
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      ticketId: data.ticketId.present ? data.ticketId.value : this.ticketId,
      allocatedAmountCents: data.allocatedAmountCents.present
          ? data.allocatedAmountCents.value
          : this.allocatedAmountCents,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceTicket(')
          ..write('invoiceId: $invoiceId, ')
          ..write('ticketId: $ticketId, ')
          ..write('allocatedAmountCents: $allocatedAmountCents, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(invoiceId, ticketId, allocatedAmountCents, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceTicket &&
          other.invoiceId == this.invoiceId &&
          other.ticketId == this.ticketId &&
          other.allocatedAmountCents == this.allocatedAmountCents &&
          other.addedAt == this.addedAt);
}

class InvoiceTicketsCompanion extends UpdateCompanion<InvoiceTicket> {
  final Value<String> invoiceId;
  final Value<String> ticketId;
  final Value<int?> allocatedAmountCents;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const InvoiceTicketsCompanion({
    this.invoiceId = const Value.absent(),
    this.ticketId = const Value.absent(),
    this.allocatedAmountCents = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoiceTicketsCompanion.insert({
    required String invoiceId,
    required String ticketId,
    this.allocatedAmountCents = const Value.absent(),
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : invoiceId = Value(invoiceId),
       ticketId = Value(ticketId),
       addedAt = Value(addedAt);
  static Insertable<InvoiceTicket> custom({
    Expression<String>? invoiceId,
    Expression<String>? ticketId,
    Expression<int>? allocatedAmountCents,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (ticketId != null) 'ticket_id': ticketId,
      if (allocatedAmountCents != null)
        'allocated_amount_cents': allocatedAmountCents,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoiceTicketsCompanion copyWith({
    Value<String>? invoiceId,
    Value<String>? ticketId,
    Value<int?>? allocatedAmountCents,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return InvoiceTicketsCompanion(
      invoiceId: invoiceId ?? this.invoiceId,
      ticketId: ticketId ?? this.ticketId,
      allocatedAmountCents: allocatedAmountCents ?? this.allocatedAmountCents,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (invoiceId.present) {
      map['invoice_id'] = Variable<String>(invoiceId.value);
    }
    if (ticketId.present) {
      map['ticket_id'] = Variable<String>(ticketId.value);
    }
    if (allocatedAmountCents.present) {
      map['allocated_amount_cents'] = Variable<int>(allocatedAmountCents.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceTicketsCompanion(')
          ..write('invoiceId: $invoiceId, ')
          ..write('ticketId: $ticketId, ')
          ..write('allocatedAmountCents: $allocatedAmountCents, ')
          ..write('addedAt: $addedAt, ')
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tickets (id) ON DELETE CASCADE',
    ),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES invoices (id) ON DELETE SET NULL',
    ),
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
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipAmountCentsMeta = const VerificationMeta(
    'tipAmountCents',
  );
  @override
  late final GeneratedColumn<int> tipAmountCents = GeneratedColumn<int>(
    'tip_amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxAmountCentsMeta = const VerificationMeta(
    'taxAmountCents',
  );
  @override
  late final GeneratedColumn<int> taxAmountCents = GeneratedColumn<int>(
    'tax_amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _discountAmountCentsMeta =
      const VerificationMeta('discountAmountCents');
  @override
  late final GeneratedColumn<int> discountAmountCents = GeneratedColumn<int>(
    'discount_amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountCentsMeta = const VerificationMeta(
    'totalAmountCents',
  );
  @override
  late final GeneratedColumn<int> totalAmountCents = GeneratedColumn<int>(
    'total_amount_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
    'processed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _processedByMeta = const VerificationMeta(
    'processedBy',
  );
  @override
  late final GeneratedColumn<int> processedBy = GeneratedColumn<int>(
    'processed_by',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _authorizedByMeta = const VerificationMeta(
    'authorizedBy',
  );
  @override
  late final GeneratedColumn<int> authorizedBy = GeneratedColumn<int>(
    'authorized_by',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE SET NULL',
    ),
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ticketId,
    invoiceId,
    paymentMethod,
    amountCents,
    tipAmountCents,
    taxAmountCents,
    discountAmountCents,
    totalAmountCents,
    discountType,
    discountCode,
    discountReason,
    cardType,
    lastFourDigits,
    transactionId,
    authorizationCode,
    processedAt,
    processedBy,
    authorizedBy,
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
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('tip_amount_cents')) {
      context.handle(
        _tipAmountCentsMeta,
        tipAmountCents.isAcceptableOrUnknown(
          data['tip_amount_cents']!,
          _tipAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('tax_amount_cents')) {
      context.handle(
        _taxAmountCentsMeta,
        taxAmountCents.isAcceptableOrUnknown(
          data['tax_amount_cents']!,
          _taxAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('discount_amount_cents')) {
      context.handle(
        _discountAmountCentsMeta,
        discountAmountCents.isAcceptableOrUnknown(
          data['discount_amount_cents']!,
          _discountAmountCentsMeta,
        ),
      );
    }
    if (data.containsKey('total_amount_cents')) {
      context.handle(
        _totalAmountCentsMeta,
        totalAmountCents.isAcceptableOrUnknown(
          data['total_amount_cents']!,
          _totalAmountCentsMeta,
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
    if (data.containsKey('authorized_by')) {
      context.handle(
        _authorizedByMeta,
        authorizedBy.isAcceptableOrUnknown(
          data['authorized_by']!,
          _authorizedByMeta,
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
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      tipAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tip_amount_cents'],
      ),
      taxAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax_amount_cents'],
      ),
      discountAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_amount_cents'],
      ),
      totalAmountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount_cents'],
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
        DriftSqlType.dateTime,
        data['${effectivePrefix}processed_at'],
      ),
      processedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processed_by'],
      ),
      authorizedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}authorized_by'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
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
  final int amountCents;
  final int? tipAmountCents;
  final int? taxAmountCents;
  final int? discountAmountCents;
  final int? totalAmountCents;
  final String? discountType;
  final String? discountCode;
  final String? discountReason;
  final String? cardType;
  final String? lastFourDigits;
  final String? transactionId;
  final String? authorizationCode;
  final DateTime? processedAt;
  final int? processedBy;
  final int? authorizedBy;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Payment({
    required this.id,
    required this.ticketId,
    this.invoiceId,
    required this.paymentMethod,
    required this.amountCents,
    this.tipAmountCents,
    this.taxAmountCents,
    this.discountAmountCents,
    this.totalAmountCents,
    this.discountType,
    this.discountCode,
    this.discountReason,
    this.cardType,
    this.lastFourDigits,
    this.transactionId,
    this.authorizationCode,
    this.processedAt,
    this.processedBy,
    this.authorizedBy,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
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
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || tipAmountCents != null) {
      map['tip_amount_cents'] = Variable<int>(tipAmountCents);
    }
    if (!nullToAbsent || taxAmountCents != null) {
      map['tax_amount_cents'] = Variable<int>(taxAmountCents);
    }
    if (!nullToAbsent || discountAmountCents != null) {
      map['discount_amount_cents'] = Variable<int>(discountAmountCents);
    }
    if (!nullToAbsent || totalAmountCents != null) {
      map['total_amount_cents'] = Variable<int>(totalAmountCents);
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
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    if (!nullToAbsent || processedBy != null) {
      map['processed_by'] = Variable<int>(processedBy);
    }
    if (!nullToAbsent || authorizedBy != null) {
      map['authorized_by'] = Variable<int>(authorizedBy);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
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
      amountCents: Value(amountCents),
      tipAmountCents: tipAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(tipAmountCents),
      taxAmountCents: taxAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(taxAmountCents),
      discountAmountCents: discountAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(discountAmountCents),
      totalAmountCents: totalAmountCents == null && nullToAbsent
          ? const Value.absent()
          : Value(totalAmountCents),
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
      authorizedBy: authorizedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(authorizedBy),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      amountCents: serializer.fromJson<int>(json['amountCents']),
      tipAmountCents: serializer.fromJson<int?>(json['tipAmountCents']),
      taxAmountCents: serializer.fromJson<int?>(json['taxAmountCents']),
      discountAmountCents: serializer.fromJson<int?>(
        json['discountAmountCents'],
      ),
      totalAmountCents: serializer.fromJson<int?>(json['totalAmountCents']),
      discountType: serializer.fromJson<String?>(json['discountType']),
      discountCode: serializer.fromJson<String?>(json['discountCode']),
      discountReason: serializer.fromJson<String?>(json['discountReason']),
      cardType: serializer.fromJson<String?>(json['cardType']),
      lastFourDigits: serializer.fromJson<String?>(json['lastFourDigits']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
      authorizationCode: serializer.fromJson<String?>(
        json['authorizationCode'],
      ),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
      processedBy: serializer.fromJson<int?>(json['processedBy']),
      authorizedBy: serializer.fromJson<int?>(json['authorizedBy']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
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
      'amountCents': serializer.toJson<int>(amountCents),
      'tipAmountCents': serializer.toJson<int?>(tipAmountCents),
      'taxAmountCents': serializer.toJson<int?>(taxAmountCents),
      'discountAmountCents': serializer.toJson<int?>(discountAmountCents),
      'totalAmountCents': serializer.toJson<int?>(totalAmountCents),
      'discountType': serializer.toJson<String?>(discountType),
      'discountCode': serializer.toJson<String?>(discountCode),
      'discountReason': serializer.toJson<String?>(discountReason),
      'cardType': serializer.toJson<String?>(cardType),
      'lastFourDigits': serializer.toJson<String?>(lastFourDigits),
      'transactionId': serializer.toJson<String?>(transactionId),
      'authorizationCode': serializer.toJson<String?>(authorizationCode),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
      'processedBy': serializer.toJson<int?>(processedBy),
      'authorizedBy': serializer.toJson<int?>(authorizedBy),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Payment copyWith({
    String? id,
    String? ticketId,
    Value<String?> invoiceId = const Value.absent(),
    String? paymentMethod,
    int? amountCents,
    Value<int?> tipAmountCents = const Value.absent(),
    Value<int?> taxAmountCents = const Value.absent(),
    Value<int?> discountAmountCents = const Value.absent(),
    Value<int?> totalAmountCents = const Value.absent(),
    Value<String?> discountType = const Value.absent(),
    Value<String?> discountCode = const Value.absent(),
    Value<String?> discountReason = const Value.absent(),
    Value<String?> cardType = const Value.absent(),
    Value<String?> lastFourDigits = const Value.absent(),
    Value<String?> transactionId = const Value.absent(),
    Value<String?> authorizationCode = const Value.absent(),
    Value<DateTime?> processedAt = const Value.absent(),
    Value<int?> processedBy = const Value.absent(),
    Value<int?> authorizedBy = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Payment(
    id: id ?? this.id,
    ticketId: ticketId ?? this.ticketId,
    invoiceId: invoiceId.present ? invoiceId.value : this.invoiceId,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    amountCents: amountCents ?? this.amountCents,
    tipAmountCents: tipAmountCents.present
        ? tipAmountCents.value
        : this.tipAmountCents,
    taxAmountCents: taxAmountCents.present
        ? taxAmountCents.value
        : this.taxAmountCents,
    discountAmountCents: discountAmountCents.present
        ? discountAmountCents.value
        : this.discountAmountCents,
    totalAmountCents: totalAmountCents.present
        ? totalAmountCents.value
        : this.totalAmountCents,
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
    authorizedBy: authorizedBy.present ? authorizedBy.value : this.authorizedBy,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      id: data.id.present ? data.id.value : this.id,
      ticketId: data.ticketId.present ? data.ticketId.value : this.ticketId,
      invoiceId: data.invoiceId.present ? data.invoiceId.value : this.invoiceId,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      tipAmountCents: data.tipAmountCents.present
          ? data.tipAmountCents.value
          : this.tipAmountCents,
      taxAmountCents: data.taxAmountCents.present
          ? data.taxAmountCents.value
          : this.taxAmountCents,
      discountAmountCents: data.discountAmountCents.present
          ? data.discountAmountCents.value
          : this.discountAmountCents,
      totalAmountCents: data.totalAmountCents.present
          ? data.totalAmountCents.value
          : this.totalAmountCents,
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
      authorizedBy: data.authorizedBy.present
          ? data.authorizedBy.value
          : this.authorizedBy,
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
          ..write('amountCents: $amountCents, ')
          ..write('tipAmountCents: $tipAmountCents, ')
          ..write('taxAmountCents: $taxAmountCents, ')
          ..write('discountAmountCents: $discountAmountCents, ')
          ..write('totalAmountCents: $totalAmountCents, ')
          ..write('discountType: $discountType, ')
          ..write('discountCode: $discountCode, ')
          ..write('discountReason: $discountReason, ')
          ..write('cardType: $cardType, ')
          ..write('lastFourDigits: $lastFourDigits, ')
          ..write('transactionId: $transactionId, ')
          ..write('authorizationCode: $authorizationCode, ')
          ..write('processedAt: $processedAt, ')
          ..write('processedBy: $processedBy, ')
          ..write('authorizedBy: $authorizedBy, ')
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
    amountCents,
    tipAmountCents,
    taxAmountCents,
    discountAmountCents,
    totalAmountCents,
    discountType,
    discountCode,
    discountReason,
    cardType,
    lastFourDigits,
    transactionId,
    authorizationCode,
    processedAt,
    processedBy,
    authorizedBy,
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
          other.amountCents == this.amountCents &&
          other.tipAmountCents == this.tipAmountCents &&
          other.taxAmountCents == this.taxAmountCents &&
          other.discountAmountCents == this.discountAmountCents &&
          other.totalAmountCents == this.totalAmountCents &&
          other.discountType == this.discountType &&
          other.discountCode == this.discountCode &&
          other.discountReason == this.discountReason &&
          other.cardType == this.cardType &&
          other.lastFourDigits == this.lastFourDigits &&
          other.transactionId == this.transactionId &&
          other.authorizationCode == this.authorizationCode &&
          other.processedAt == this.processedAt &&
          other.processedBy == this.processedBy &&
          other.authorizedBy == this.authorizedBy &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> id;
  final Value<String> ticketId;
  final Value<String?> invoiceId;
  final Value<String> paymentMethod;
  final Value<int> amountCents;
  final Value<int?> tipAmountCents;
  final Value<int?> taxAmountCents;
  final Value<int?> discountAmountCents;
  final Value<int?> totalAmountCents;
  final Value<String?> discountType;
  final Value<String?> discountCode;
  final Value<String?> discountReason;
  final Value<String?> cardType;
  final Value<String?> lastFourDigits;
  final Value<String?> transactionId;
  final Value<String?> authorizationCode;
  final Value<DateTime?> processedAt;
  final Value<int?> processedBy;
  final Value<int?> authorizedBy;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.ticketId = const Value.absent(),
    this.invoiceId = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.tipAmountCents = const Value.absent(),
    this.taxAmountCents = const Value.absent(),
    this.discountAmountCents = const Value.absent(),
    this.totalAmountCents = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountCode = const Value.absent(),
    this.discountReason = const Value.absent(),
    this.cardType = const Value.absent(),
    this.lastFourDigits = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.authorizationCode = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.processedBy = const Value.absent(),
    this.authorizedBy = const Value.absent(),
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
    required int amountCents,
    this.tipAmountCents = const Value.absent(),
    this.taxAmountCents = const Value.absent(),
    this.discountAmountCents = const Value.absent(),
    this.totalAmountCents = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountCode = const Value.absent(),
    this.discountReason = const Value.absent(),
    this.cardType = const Value.absent(),
    this.lastFourDigits = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.authorizationCode = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.processedBy = const Value.absent(),
    this.authorizedBy = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ticketId = Value(ticketId),
       paymentMethod = Value(paymentMethod),
       amountCents = Value(amountCents),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Payment> custom({
    Expression<String>? id,
    Expression<String>? ticketId,
    Expression<String>? invoiceId,
    Expression<String>? paymentMethod,
    Expression<int>? amountCents,
    Expression<int>? tipAmountCents,
    Expression<int>? taxAmountCents,
    Expression<int>? discountAmountCents,
    Expression<int>? totalAmountCents,
    Expression<String>? discountType,
    Expression<String>? discountCode,
    Expression<String>? discountReason,
    Expression<String>? cardType,
    Expression<String>? lastFourDigits,
    Expression<String>? transactionId,
    Expression<String>? authorizationCode,
    Expression<DateTime>? processedAt,
    Expression<int>? processedBy,
    Expression<int>? authorizedBy,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ticketId != null) 'ticket_id': ticketId,
      if (invoiceId != null) 'invoice_id': invoiceId,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (amountCents != null) 'amount_cents': amountCents,
      if (tipAmountCents != null) 'tip_amount_cents': tipAmountCents,
      if (taxAmountCents != null) 'tax_amount_cents': taxAmountCents,
      if (discountAmountCents != null)
        'discount_amount_cents': discountAmountCents,
      if (totalAmountCents != null) 'total_amount_cents': totalAmountCents,
      if (discountType != null) 'discount_type': discountType,
      if (discountCode != null) 'discount_code': discountCode,
      if (discountReason != null) 'discount_reason': discountReason,
      if (cardType != null) 'card_type': cardType,
      if (lastFourDigits != null) 'last_four_digits': lastFourDigits,
      if (transactionId != null) 'transaction_id': transactionId,
      if (authorizationCode != null) 'authorization_code': authorizationCode,
      if (processedAt != null) 'processed_at': processedAt,
      if (processedBy != null) 'processed_by': processedBy,
      if (authorizedBy != null) 'authorized_by': authorizedBy,
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
    Value<int>? amountCents,
    Value<int?>? tipAmountCents,
    Value<int?>? taxAmountCents,
    Value<int?>? discountAmountCents,
    Value<int?>? totalAmountCents,
    Value<String?>? discountType,
    Value<String?>? discountCode,
    Value<String?>? discountReason,
    Value<String?>? cardType,
    Value<String?>? lastFourDigits,
    Value<String?>? transactionId,
    Value<String?>? authorizationCode,
    Value<DateTime?>? processedAt,
    Value<int?>? processedBy,
    Value<int?>? authorizedBy,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      invoiceId: invoiceId ?? this.invoiceId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      amountCents: amountCents ?? this.amountCents,
      tipAmountCents: tipAmountCents ?? this.tipAmountCents,
      taxAmountCents: taxAmountCents ?? this.taxAmountCents,
      discountAmountCents: discountAmountCents ?? this.discountAmountCents,
      totalAmountCents: totalAmountCents ?? this.totalAmountCents,
      discountType: discountType ?? this.discountType,
      discountCode: discountCode ?? this.discountCode,
      discountReason: discountReason ?? this.discountReason,
      cardType: cardType ?? this.cardType,
      lastFourDigits: lastFourDigits ?? this.lastFourDigits,
      transactionId: transactionId ?? this.transactionId,
      authorizationCode: authorizationCode ?? this.authorizationCode,
      processedAt: processedAt ?? this.processedAt,
      processedBy: processedBy ?? this.processedBy,
      authorizedBy: authorizedBy ?? this.authorizedBy,
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
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (tipAmountCents.present) {
      map['tip_amount_cents'] = Variable<int>(tipAmountCents.value);
    }
    if (taxAmountCents.present) {
      map['tax_amount_cents'] = Variable<int>(taxAmountCents.value);
    }
    if (discountAmountCents.present) {
      map['discount_amount_cents'] = Variable<int>(discountAmountCents.value);
    }
    if (totalAmountCents.present) {
      map['total_amount_cents'] = Variable<int>(totalAmountCents.value);
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
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (processedBy.present) {
      map['processed_by'] = Variable<int>(processedBy.value);
    }
    if (authorizedBy.present) {
      map['authorized_by'] = Variable<int>(authorizedBy.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
          ..write('amountCents: $amountCents, ')
          ..write('tipAmountCents: $tipAmountCents, ')
          ..write('taxAmountCents: $taxAmountCents, ')
          ..write('discountAmountCents: $discountAmountCents, ')
          ..write('totalAmountCents: $totalAmountCents, ')
          ..write('discountType: $discountType, ')
          ..write('discountCode: $discountCode, ')
          ..write('discountReason: $discountReason, ')
          ..write('cardType: $cardType, ')
          ..write('lastFourDigits: $lastFourDigits, ')
          ..write('transactionId: $transactionId, ')
          ..write('authorizationCode: $authorizationCode, ')
          ..write('processedAt: $processedAt, ')
          ..write('processedBy: $processedBy, ')
          ..write('authorizedBy: $authorizedBy, ')
          ..write('notes: $notes, ')
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE CASCADE',
    ),
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
  late final GeneratedColumn<bool> isScheduledOff = GeneratedColumn<bool>(
    'is_scheduled_off',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_scheduled_off" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  late final GeneratedColumn<DateTime> effectiveDate =
      GeneratedColumn<DateTime>(
        'effective_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
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
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
        DriftSqlType.bool,
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
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
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
  final bool isScheduledOff;
  final int? startTime;
  final int? endTime;
  final DateTime? effectiveDate;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
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
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<int>(employeeId);
    map['day_of_week'] = Variable<String>(dayOfWeek);
    map['is_scheduled_off'] = Variable<bool>(isScheduledOff);
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<int>(startTime);
    }
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<int>(endTime);
    }
    if (!nullToAbsent || effectiveDate != null) {
      map['effective_date'] = Variable<DateTime>(effectiveDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
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
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      isScheduledOff: serializer.fromJson<bool>(json['isScheduledOff']),
      startTime: serializer.fromJson<int?>(json['startTime']),
      endTime: serializer.fromJson<int?>(json['endTime']),
      effectiveDate: serializer.fromJson<DateTime?>(json['effectiveDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'dayOfWeek': serializer.toJson<String>(dayOfWeek),
      'isScheduledOff': serializer.toJson<bool>(isScheduledOff),
      'startTime': serializer.toJson<int?>(startTime),
      'endTime': serializer.toJson<int?>(endTime),
      'effectiveDate': serializer.toJson<DateTime?>(effectiveDate),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TechnicianSchedule copyWith({
    String? id,
    int? employeeId,
    String? dayOfWeek,
    bool? isScheduledOff,
    Value<int?> startTime = const Value.absent(),
    Value<int?> endTime = const Value.absent(),
    Value<DateTime?> effectiveDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
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
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
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
  final Value<bool> isScheduledOff;
  final Value<int?> startTime;
  final Value<int?> endTime;
  final Value<DateTime?> effectiveDate;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
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
    this.isScheduledOff = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employeeId = Value(employeeId),
       dayOfWeek = Value(dayOfWeek),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TechnicianSchedule> custom({
    Expression<String>? id,
    Expression<int>? employeeId,
    Expression<String>? dayOfWeek,
    Expression<bool>? isScheduledOff,
    Expression<int>? startTime,
    Expression<int>? endTime,
    Expression<DateTime>? effectiveDate,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
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
    Value<bool>? isScheduledOff,
    Value<int?>? startTime,
    Value<int?>? endTime,
    Value<DateTime?>? effectiveDate,
    Value<String?>? notes,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
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
      map['is_scheduled_off'] = Variable<bool>(isScheduledOff.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<int>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<int>(endTime.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<DateTime>(effectiveDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _clockInMeta = const VerificationMeta(
    'clockIn',
  );
  @override
  late final GeneratedColumn<DateTime> clockIn = GeneratedColumn<DateTime>(
    'clock_in',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clockOutMeta = const VerificationMeta(
    'clockOut',
  );
  @override
  late final GeneratedColumn<DateTime> clockOut = GeneratedColumn<DateTime>(
    'clock_out',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
  late final GeneratedColumn<int> editedBy = GeneratedColumn<int>(
    'edited_by',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id) ON DELETE SET NULL',
    ),
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
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
        DriftSqlType.dateTime,
        data['${effectivePrefix}clock_in'],
      )!,
      clockOut: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
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
        DriftSqlType.int,
        data['${effectivePrefix}edited_by'],
      ),
      editReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edit_reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
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
  final DateTime clockIn;
  final DateTime? clockOut;
  final int breakMinutes;
  final double? totalHours;
  final String status;
  final int? editedBy;
  final String? editReason;
  final DateTime createdAt;
  final DateTime updatedAt;
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
    map['clock_in'] = Variable<DateTime>(clockIn);
    if (!nullToAbsent || clockOut != null) {
      map['clock_out'] = Variable<DateTime>(clockOut);
    }
    map['break_minutes'] = Variable<int>(breakMinutes);
    if (!nullToAbsent || totalHours != null) {
      map['total_hours'] = Variable<double>(totalHours);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || editedBy != null) {
      map['edited_by'] = Variable<int>(editedBy);
    }
    if (!nullToAbsent || editReason != null) {
      map['edit_reason'] = Variable<String>(editReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
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
      clockIn: serializer.fromJson<DateTime>(json['clockIn']),
      clockOut: serializer.fromJson<DateTime?>(json['clockOut']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      totalHours: serializer.fromJson<double?>(json['totalHours']),
      status: serializer.fromJson<String>(json['status']),
      editedBy: serializer.fromJson<int?>(json['editedBy']),
      editReason: serializer.fromJson<String?>(json['editReason']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<int>(employeeId),
      'clockIn': serializer.toJson<DateTime>(clockIn),
      'clockOut': serializer.toJson<DateTime?>(clockOut),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'totalHours': serializer.toJson<double?>(totalHours),
      'status': serializer.toJson<String>(status),
      'editedBy': serializer.toJson<int?>(editedBy),
      'editReason': serializer.toJson<String?>(editReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TimeEntry copyWith({
    String? id,
    int? employeeId,
    DateTime? clockIn,
    Value<DateTime?> clockOut = const Value.absent(),
    int? breakMinutes,
    Value<double?> totalHours = const Value.absent(),
    String? status,
    Value<int?> editedBy = const Value.absent(),
    Value<String?> editReason = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
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
  final Value<DateTime> clockIn;
  final Value<DateTime?> clockOut;
  final Value<int> breakMinutes;
  final Value<double?> totalHours;
  final Value<String> status;
  final Value<int?> editedBy;
  final Value<String?> editReason;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
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
    required DateTime clockIn,
    this.clockOut = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.totalHours = const Value.absent(),
    this.status = const Value.absent(),
    this.editedBy = const Value.absent(),
    this.editReason = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employeeId = Value(employeeId),
       clockIn = Value(clockIn),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TimeEntry> custom({
    Expression<String>? id,
    Expression<int>? employeeId,
    Expression<DateTime>? clockIn,
    Expression<DateTime>? clockOut,
    Expression<int>? breakMinutes,
    Expression<double>? totalHours,
    Expression<String>? status,
    Expression<int>? editedBy,
    Expression<String>? editReason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
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
    Value<DateTime>? clockIn,
    Value<DateTime?>? clockOut,
    Value<int>? breakMinutes,
    Value<double?>? totalHours,
    Value<String>? status,
    Value<int?>? editedBy,
    Value<String?>? editReason,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
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
      map['clock_in'] = Variable<DateTime>(clockIn.value);
    }
    if (clockOut.present) {
      map['clock_out'] = Variable<DateTime>(clockOut.value);
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
      map['edited_by'] = Variable<int>(editedBy.value);
    }
    if (editReason.present) {
      map['edit_reason'] = Variable<String>(editReason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
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
  final bool isSystem;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Setting({
    required this.key,
    required this.value,
    this.category,
    this.dataType,
    this.description,
    required this.isSystem,
    required this.createdAt,
    required this.updatedAt,
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
    map['is_system'] = Variable<bool>(isSystem);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
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
      isSystem: Value(isSystem),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
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
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
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
      'isSystem': serializer.toJson<bool>(isSystem),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Setting copyWith({
    String? key,
    String? value,
    Value<String?> category = const Value.absent(),
    Value<String?> dataType = const Value.absent(),
    Value<String?> description = const Value.absent(),
    bool? isSystem,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Setting(
    key: key ?? this.key,
    value: value ?? this.value,
    category: category.present ? category.value : this.category,
    dataType: dataType.present ? dataType.value : this.dataType,
    description: description.present ? description.value : this.description,
    isSystem: isSystem ?? this.isSystem,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
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
  final Value<bool> isSystem;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
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
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? category,
    Expression<String>? dataType,
    Expression<String>? description,
    Expression<bool>? isSystem,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
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
    Value<bool>? isSystem,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
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
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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

abstract class _$PosDatabase extends GeneratedDatabase {
  _$PosDatabase(QueryExecutor e) : super(e);
  $PosDatabaseManager get managers => $PosDatabaseManager(this);
  late final $ServiceCategoriesTable serviceCategories =
      $ServiceCategoriesTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $ServicesTable services = $ServicesTable(this);
  late final $EmployeeServiceCategoriesTable employeeServiceCategories =
      $EmployeeServiceCategoriesTable(this);
  late final $AppointmentsTable appointments = $AppointmentsTable(this);
  late final $TicketsTable tickets = $TicketsTable(this);
  late final $TicketServicesTable ticketServices = $TicketServicesTable(this);
  late final $AppointmentServicesTable appointmentServices =
      $AppointmentServicesTable(this);
  late final $InvoicesTable invoices = $InvoicesTable(this);
  late final $InvoiceTicketsTable invoiceTickets = $InvoiceTicketsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $TechnicianSchedulesTable technicianSchedules =
      $TechnicianSchedulesTable(this);
  late final $TimeEntriesTable timeEntries = $TimeEntriesTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final EmployeeDao employeeDao = EmployeeDao(this as PosDatabase);
  late final CustomerDao customerDao = CustomerDao(this as PosDatabase);
  late final TicketDao ticketDao = TicketDao(this as PosDatabase);
  late final InvoiceDao invoiceDao = InvoiceDao(this as PosDatabase);
  late final PaymentDao paymentDao = PaymentDao(this as PosDatabase);
  late final AppointmentDao appointmentDao = AppointmentDao(
    this as PosDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    serviceCategories,
    employees,
    customers,
    services,
    employeeServiceCategories,
    appointments,
    tickets,
    ticketServices,
    appointmentServices,
    invoices,
    invoiceTickets,
    payments,
    technicianSchedules,
    timeEntries,
    settings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('customers', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('services', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('employee_service_categories', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'service_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [
        TableUpdate('employee_service_categories', kind: UpdateKind.delete),
      ],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'customers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('appointments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('appointments', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'customers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tickets', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tickets', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'appointments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tickets', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tickets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ticket_services', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'services',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ticket_services', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ticket_services', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'appointments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('appointment_services', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'services',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('appointment_services', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('appointment_services', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('invoice_tickets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tickets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('invoice_tickets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tickets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('payments', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'invoices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('payments', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('payments', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('payments', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('technician_schedules', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('time_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'employees',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('time_entries', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$ServiceCategoriesTableCreateCompanionBuilder =
    ServiceCategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> color,
      Value<String?> icon,
    });
typedef $$ServiceCategoriesTableUpdateCompanionBuilder =
    ServiceCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> color,
      Value<String?> icon,
    });

final class $$ServiceCategoriesTableReferences
    extends
        BaseReferences<
          _$PosDatabase,
          $ServiceCategoriesTable,
          ServiceCategory
        > {
  $$ServiceCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ServicesTable, List<Service>> _servicesRefsTable(
    _$PosDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.services,
    aliasName: $_aliasNameGenerator(
      db.serviceCategories.id,
      db.services.categoryId,
    ),
  );

  $$ServicesTableProcessedTableManager get servicesRefs {
    final manager = $$ServicesTableTableManager(
      $_db,
      $_db.services,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_servicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EmployeeServiceCategoriesTable,
    List<EmployeeServiceCategory>
  >
  _employeeServiceCategoriesRefsTable(_$PosDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.employeeServiceCategories,
        aliasName: $_aliasNameGenerator(
          db.serviceCategories.id,
          db.employeeServiceCategories.categoryId,
        ),
      );

  $$EmployeeServiceCategoriesTableProcessedTableManager
  get employeeServiceCategoriesRefs {
    final manager = $$EmployeeServiceCategoriesTableTableManager(
      $_db,
      $_db.employeeServiceCategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _employeeServiceCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ServiceCategoriesTableFilterComposer
    extends Composer<_$PosDatabase, $ServiceCategoriesTable> {
  $$ServiceCategoriesTableFilterComposer({
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

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> servicesRefs(
    Expression<bool> Function($$ServicesTableFilterComposer f) f,
  ) {
    final $$ServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableFilterComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> employeeServiceCategoriesRefs(
    Expression<bool> Function($$EmployeeServiceCategoriesTableFilterComposer f)
    f,
  ) {
    final $$EmployeeServiceCategoriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.employeeServiceCategories,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmployeeServiceCategoriesTableFilterComposer(
                $db: $db,
                $table: $db.employeeServiceCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
  ColumnOrderings<int> get id => $composableBuilder(
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
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  Expression<T> servicesRefs<T extends Object>(
    Expression<T> Function($$ServicesTableAnnotationComposer a) f,
  ) {
    final $$ServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> employeeServiceCategoriesRefs<T extends Object>(
    Expression<T> Function($$EmployeeServiceCategoriesTableAnnotationComposer a)
    f,
  ) {
    final $$EmployeeServiceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.employeeServiceCategories,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmployeeServiceCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.employeeServiceCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (ServiceCategory, $$ServiceCategoriesTableReferences),
          ServiceCategory,
          PrefetchHooks Function({
            bool servicesRefs,
            bool employeeServiceCategoriesRefs,
          })
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
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
              }) => ServiceCategoriesCompanion(
                id: id,
                name: name,
                color: color,
                icon: icon,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
              }) => ServiceCategoriesCompanion.insert(
                id: id,
                name: name,
                color: color,
                icon: icon,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServiceCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({servicesRefs = false, employeeServiceCategoriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (servicesRefs) db.services,
                    if (employeeServiceCategoriesRefs)
                      db.employeeServiceCategories,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (servicesRefs)
                        await $_getPrefetchedData<
                          ServiceCategory,
                          $ServiceCategoriesTable,
                          Service
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceCategoriesTableReferences
                              ._servicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).servicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (employeeServiceCategoriesRefs)
                        await $_getPrefetchedData<
                          ServiceCategory,
                          $ServiceCategoriesTable,
                          EmployeeServiceCategory
                        >(
                          currentTable: table,
                          referencedTable: $$ServiceCategoriesTableReferences
                              ._employeeServiceCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServiceCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).employeeServiceCategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (ServiceCategory, $$ServiceCategoriesTableReferences),
      ServiceCategory,
      PrefetchHooks Function({
        bool servicesRefs,
        bool employeeServiceCategoriesRefs,
      })
    >;
typedef $$EmployeesTableCreateCompanionBuilder =
    EmployeesCompanion Function({
      Value<int> id,
      required String firstName,
      required String lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<String?> socialSecurityNumber,
      Value<String> role,
      Value<int?> commissionRateCents,
      Value<int?> hourlyRateCents,
      required DateTime hireDate,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> clockedInAt,
      Value<DateTime?> clockedOutAt,
      Value<bool> isClockedIn,
      Value<String?> pinHash,
      Value<String?> pinSalt,
      Value<DateTime?> pinCreatedAt,
      Value<DateTime?> pinLastUsedAt,
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
      Value<int?> commissionRateCents,
      Value<int?> hourlyRateCents,
      Value<DateTime> hireDate,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> clockedInAt,
      Value<DateTime?> clockedOutAt,
      Value<bool> isClockedIn,
      Value<String?> pinHash,
      Value<String?> pinSalt,
      Value<DateTime?> pinCreatedAt,
      Value<DateTime?> pinLastUsedAt,
    });

final class $$EmployeesTableReferences
    extends BaseReferences<_$PosDatabase, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomersTable, List<Customer>>
  _customersRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.customers,
    aliasName: $_aliasNameGenerator(
      db.employees.id,
      db.customers.preferredTechnicianId,
    ),
  );

  $$CustomersTableProcessedTableManager get customersRefs {
    final manager = $$CustomersTableTableManager($_db, $_db.customers).filter(
      (f) => f.preferredTechnicianId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_customersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $EmployeeServiceCategoriesTable,
    List<EmployeeServiceCategory>
  >
  _employeeServiceCategoriesRefsTable(_$PosDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.employeeServiceCategories,
        aliasName: $_aliasNameGenerator(
          db.employees.id,
          db.employeeServiceCategories.employeeId,
        ),
      );

  $$EmployeeServiceCategoriesTableProcessedTableManager
  get employeeServiceCategoriesRefs {
    final manager = $$EmployeeServiceCategoriesTableTableManager(
      $_db,
      $_db.employeeServiceCategories,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _employeeServiceCategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AppointmentsTable, List<Appointment>>
  _assignedAppointmentsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.appointments,
    aliasName: $_aliasNameGenerator(
      db.employees.id,
      db.appointments.employeeId,
    ),
  );

  $$AppointmentsTableProcessedTableManager get assignedAppointments {
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _assignedAppointmentsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AppointmentsTable, List<Appointment>>
  _modifiedAppointmentsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.appointments,
    aliasName: $_aliasNameGenerator(
      db.employees.id,
      db.appointments.lastModifiedBy,
    ),
  );

  $$AppointmentsTableProcessedTableManager get modifiedAppointments {
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.lastModifiedBy.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _modifiedAppointmentsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TicketsTable, List<Ticket>> _createdTicketsTable(
    _$PosDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tickets,
    aliasName: $_aliasNameGenerator(db.employees.id, db.tickets.employeeId),
  );

  $$TicketsTableProcessedTableManager get createdTickets {
    final manager = $$TicketsTableTableManager(
      $_db,
      $_db.tickets,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_createdTicketsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TicketsTable, List<Ticket>> _assignedTicketsTable(
    _$PosDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tickets,
    aliasName: $_aliasNameGenerator(
      db.employees.id,
      db.tickets.assignedTechnicianId,
    ),
  );

  $$TicketsTableProcessedTableManager get assignedTickets {
    final manager = $$TicketsTableTableManager($_db, $_db.tickets).filter(
      (f) => f.assignedTechnicianId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_assignedTicketsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TicketServicesTable, List<TicketService>>
  _ticketServicesRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.ticketServices,
    aliasName: $_aliasNameGenerator(
      db.employees.id,
      db.ticketServices.assignedTechnicianId,
    ),
  );

  $$TicketServicesTableProcessedTableManager get ticketServicesRefs {
    final manager = $$TicketServicesTableTableManager($_db, $_db.ticketServices)
        .filter(
          (f) => f.assignedTechnicianId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_ticketServicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AppointmentServicesTable,
    List<AppointmentService>
  >
  _appointmentServicesRefsTable(_$PosDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.appointmentServices,
        aliasName: $_aliasNameGenerator(
          db.employees.id,
          db.appointmentServices.assignedTechnicianId,
        ),
      );

  $$AppointmentServicesTableProcessedTableManager get appointmentServicesRefs {
    final manager =
        $$AppointmentServicesTableTableManager(
          $_db,
          $_db.appointmentServices,
        ).filter(
          (f) => f.assignedTechnicianId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _appointmentServicesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoicesTable, List<Invoice>> _invoicesRefsTable(
    _$PosDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.invoices,
    aliasName: $_aliasNameGenerator(db.employees.id, db.invoices.processedBy),
  );

  $$InvoicesTableProcessedTableManager get invoicesRefs {
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.processedBy.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>>
  _processedPaymentsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.employees.id, db.payments.processedBy),
  );

  $$PaymentsTableProcessedTableManager get processedPayments {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.processedBy.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_processedPaymentsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>>
  _authorizedPaymentsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.employees.id, db.payments.authorizedBy),
  );

  $$PaymentsTableProcessedTableManager get authorizedPayments {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.authorizedBy.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_authorizedPaymentsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $TechnicianSchedulesTable,
    List<TechnicianSchedule>
  >
  _technicianSchedulesRefsTable(_$PosDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.technicianSchedules,
        aliasName: $_aliasNameGenerator(
          db.employees.id,
          db.technicianSchedules.employeeId,
        ),
      );

  $$TechnicianSchedulesTableProcessedTableManager get technicianSchedulesRefs {
    final manager = $$TechnicianSchedulesTableTableManager(
      $_db,
      $_db.technicianSchedules,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _technicianSchedulesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _employeeTimeEntriesTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.employees.id, db.timeEntries.employeeId),
  );

  $$TimeEntriesTableProcessedTableManager get employeeTimeEntries {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _employeeTimeEntriesTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _editedTimeEntriesTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.employees.id, db.timeEntries.editedBy),
  );

  $$TimeEntriesTableProcessedTableManager get editedTimeEntries {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.editedBy.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_editedTimeEntriesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<int> get commissionRateCents => $composableBuilder(
    column: $table.commissionRateCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hourlyRateCents => $composableBuilder(
    column: $table.hourlyRateCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get hireDate => $composableBuilder(
    column: $table.hireDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
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

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pinCreatedAt => $composableBuilder(
    column: $table.pinCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get pinLastUsedAt => $composableBuilder(
    column: $table.pinLastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customersRefs(
    Expression<bool> Function($$CustomersTableFilterComposer f) f,
  ) {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.preferredTechnicianId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> employeeServiceCategoriesRefs(
    Expression<bool> Function($$EmployeeServiceCategoriesTableFilterComposer f)
    f,
  ) {
    final $$EmployeeServiceCategoriesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.employeeServiceCategories,
          getReferencedColumn: (t) => t.employeeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmployeeServiceCategoriesTableFilterComposer(
                $db: $db,
                $table: $db.employeeServiceCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> assignedAppointments(
    Expression<bool> Function($$AppointmentsTableFilterComposer f) f,
  ) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> modifiedAppointments(
    Expression<bool> Function($$AppointmentsTableFilterComposer f) f,
  ) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.lastModifiedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> createdTickets(
    Expression<bool> Function($$TicketsTableFilterComposer f) f,
  ) {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> assignedTickets(
    Expression<bool> Function($$TicketsTableFilterComposer f) f,
  ) {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.assignedTechnicianId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ticketServicesRefs(
    Expression<bool> Function($$TicketServicesTableFilterComposer f) f,
  ) {
    final $$TicketServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketServices,
      getReferencedColumn: (t) => t.assignedTechnicianId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketServicesTableFilterComposer(
            $db: $db,
            $table: $db.ticketServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appointmentServicesRefs(
    Expression<bool> Function($$AppointmentServicesTableFilterComposer f) f,
  ) {
    final $$AppointmentServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointmentServices,
      getReferencedColumn: (t) => t.assignedTechnicianId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentServicesTableFilterComposer(
            $db: $db,
            $table: $db.appointmentServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoicesRefs(
    Expression<bool> Function($$InvoicesTableFilterComposer f) f,
  ) {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.processedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> processedPayments(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.processedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> authorizedPayments(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.authorizedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> technicianSchedulesRefs(
    Expression<bool> Function($$TechnicianSchedulesTableFilterComposer f) f,
  ) {
    final $$TechnicianSchedulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.technicianSchedules,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TechnicianSchedulesTableFilterComposer(
            $db: $db,
            $table: $db.technicianSchedules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> employeeTimeEntries(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> editedTimeEntries(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.editedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<int> get commissionRateCents => $composableBuilder(
    column: $table.commissionRateCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hourlyRateCents => $composableBuilder(
    column: $table.hourlyRateCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get hireDate => $composableBuilder(
    column: $table.hireDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
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

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pinCreatedAt => $composableBuilder(
    column: $table.pinCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get pinLastUsedAt => $composableBuilder(
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

  GeneratedColumn<int> get commissionRateCents => $composableBuilder(
    column: $table.commissionRateCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hourlyRateCents => $composableBuilder(
    column: $table.hourlyRateCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get hireDate =>
      $composableBuilder(column: $table.hireDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
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

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<DateTime> get pinCreatedAt => $composableBuilder(
    column: $table.pinCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get pinLastUsedAt => $composableBuilder(
    column: $table.pinLastUsedAt,
    builder: (column) => column,
  );

  Expression<T> customersRefs<T extends Object>(
    Expression<T> Function($$CustomersTableAnnotationComposer a) f,
  ) {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.preferredTechnicianId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> employeeServiceCategoriesRefs<T extends Object>(
    Expression<T> Function($$EmployeeServiceCategoriesTableAnnotationComposer a)
    f,
  ) {
    final $$EmployeeServiceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.employeeServiceCategories,
          getReferencedColumn: (t) => t.employeeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$EmployeeServiceCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.employeeServiceCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> assignedAppointments<T extends Object>(
    Expression<T> Function($$AppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> modifiedAppointments<T extends Object>(
    Expression<T> Function($$AppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.lastModifiedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> createdTickets<T extends Object>(
    Expression<T> Function($$TicketsTableAnnotationComposer a) f,
  ) {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> assignedTickets<T extends Object>(
    Expression<T> Function($$TicketsTableAnnotationComposer a) f,
  ) {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.assignedTechnicianId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ticketServicesRefs<T extends Object>(
    Expression<T> Function($$TicketServicesTableAnnotationComposer a) f,
  ) {
    final $$TicketServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketServices,
      getReferencedColumn: (t) => t.assignedTechnicianId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.ticketServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> appointmentServicesRefs<T extends Object>(
    Expression<T> Function($$AppointmentServicesTableAnnotationComposer a) f,
  ) {
    final $$AppointmentServicesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.appointmentServices,
          getReferencedColumn: (t) => t.assignedTechnicianId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AppointmentServicesTableAnnotationComposer(
                $db: $db,
                $table: $db.appointmentServices,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> invoicesRefs<T extends Object>(
    Expression<T> Function($$InvoicesTableAnnotationComposer a) f,
  ) {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.processedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> processedPayments<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.processedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> authorizedPayments<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.authorizedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> technicianSchedulesRefs<T extends Object>(
    Expression<T> Function($$TechnicianSchedulesTableAnnotationComposer a) f,
  ) {
    final $$TechnicianSchedulesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.technicianSchedules,
          getReferencedColumn: (t) => t.employeeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TechnicianSchedulesTableAnnotationComposer(
                $db: $db,
                $table: $db.technicianSchedules,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> employeeTimeEntries<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> editedTimeEntries<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.editedBy,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Employee, $$EmployeesTableReferences),
          Employee,
          PrefetchHooks Function({
            bool customersRefs,
            bool employeeServiceCategoriesRefs,
            bool assignedAppointments,
            bool modifiedAppointments,
            bool createdTickets,
            bool assignedTickets,
            bool ticketServicesRefs,
            bool appointmentServicesRefs,
            bool invoicesRefs,
            bool processedPayments,
            bool authorizedPayments,
            bool technicianSchedulesRefs,
            bool employeeTimeEntries,
            bool editedTimeEntries,
          })
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
                Value<int?> commissionRateCents = const Value.absent(),
                Value<int?> hourlyRateCents = const Value.absent(),
                Value<DateTime> hireDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> clockedInAt = const Value.absent(),
                Value<DateTime?> clockedOutAt = const Value.absent(),
                Value<bool> isClockedIn = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
                Value<String?> pinSalt = const Value.absent(),
                Value<DateTime?> pinCreatedAt = const Value.absent(),
                Value<DateTime?> pinLastUsedAt = const Value.absent(),
              }) => EmployeesCompanion(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                socialSecurityNumber: socialSecurityNumber,
                role: role,
                commissionRateCents: commissionRateCents,
                hourlyRateCents: hourlyRateCents,
                hireDate: hireDate,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                clockedInAt: clockedInAt,
                clockedOutAt: clockedOutAt,
                isClockedIn: isClockedIn,
                pinHash: pinHash,
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
                Value<String> role = const Value.absent(),
                Value<int?> commissionRateCents = const Value.absent(),
                Value<int?> hourlyRateCents = const Value.absent(),
                required DateTime hireDate,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> clockedInAt = const Value.absent(),
                Value<DateTime?> clockedOutAt = const Value.absent(),
                Value<bool> isClockedIn = const Value.absent(),
                Value<String?> pinHash = const Value.absent(),
                Value<String?> pinSalt = const Value.absent(),
                Value<DateTime?> pinCreatedAt = const Value.absent(),
                Value<DateTime?> pinLastUsedAt = const Value.absent(),
              }) => EmployeesCompanion.insert(
                id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                phone: phone,
                socialSecurityNumber: socialSecurityNumber,
                role: role,
                commissionRateCents: commissionRateCents,
                hourlyRateCents: hourlyRateCents,
                hireDate: hireDate,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                clockedInAt: clockedInAt,
                clockedOutAt: clockedOutAt,
                isClockedIn: isClockedIn,
                pinHash: pinHash,
                pinSalt: pinSalt,
                pinCreatedAt: pinCreatedAt,
                pinLastUsedAt: pinLastUsedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customersRefs = false,
                employeeServiceCategoriesRefs = false,
                assignedAppointments = false,
                modifiedAppointments = false,
                createdTickets = false,
                assignedTickets = false,
                ticketServicesRefs = false,
                appointmentServicesRefs = false,
                invoicesRefs = false,
                processedPayments = false,
                authorizedPayments = false,
                technicianSchedulesRefs = false,
                employeeTimeEntries = false,
                editedTimeEntries = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (customersRefs) db.customers,
                    if (employeeServiceCategoriesRefs)
                      db.employeeServiceCategories,
                    if (assignedAppointments) db.appointments,
                    if (modifiedAppointments) db.appointments,
                    if (createdTickets) db.tickets,
                    if (assignedTickets) db.tickets,
                    if (ticketServicesRefs) db.ticketServices,
                    if (appointmentServicesRefs) db.appointmentServices,
                    if (invoicesRefs) db.invoices,
                    if (processedPayments) db.payments,
                    if (authorizedPayments) db.payments,
                    if (technicianSchedulesRefs) db.technicianSchedules,
                    if (employeeTimeEntries) db.timeEntries,
                    if (editedTimeEntries) db.timeEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (customersRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Customer
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._customersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).customersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.preferredTechnicianId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (employeeServiceCategoriesRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          EmployeeServiceCategory
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._employeeServiceCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).employeeServiceCategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (assignedAppointments)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Appointment
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._assignedAppointmentsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).assignedAppointments,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (modifiedAppointments)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Appointment
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._modifiedAppointmentsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).modifiedAppointments,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.lastModifiedBy == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (createdTickets)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Ticket
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._createdTicketsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).createdTickets,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (assignedTickets)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Ticket
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._assignedTicketsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).assignedTickets,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assignedTechnicianId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ticketServicesRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          TicketService
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._ticketServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assignedTechnicianId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (appointmentServicesRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          AppointmentService
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._appointmentServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.assignedTechnicianId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoicesRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Invoice
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._invoicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.processedBy == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (processedPayments)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._processedPaymentsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).processedPayments,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.processedBy == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (authorizedPayments)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._authorizedPaymentsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).authorizedPayments,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.authorizedBy == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (technicianSchedulesRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          TechnicianSchedule
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._technicianSchedulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).technicianSchedulesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (employeeTimeEntries)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          TimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._employeeTimeEntriesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).employeeTimeEntries,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (editedTimeEntries)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          TimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._editedTimeEntriesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).editedTimeEntries,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.editedBy == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (Employee, $$EmployeesTableReferences),
      Employee,
      PrefetchHooks Function({
        bool customersRefs,
        bool employeeServiceCategoriesRefs,
        bool assignedAppointments,
        bool modifiedAppointments,
        bool createdTickets,
        bool assignedTickets,
        bool ticketServicesRefs,
        bool appointmentServicesRefs,
        bool invoicesRefs,
        bool processedPayments,
        bool authorizedPayments,
        bool technicianSchedulesRefs,
        bool employeeTimeEntries,
        bool editedTimeEntries,
      })
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String firstName,
      required String lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<DateTime?> dateOfBirth,
      Value<String?> gender,
      Value<String?> address,
      Value<String?> city,
      Value<String?> state,
      Value<String?> zipCode,
      Value<int> loyaltyPoints,
      Value<DateTime?> lastVisit,
      Value<int?> preferredTechnicianId,
      Value<String?> notes,
      Value<String?> allergies,
      Value<bool> emailOptIn,
      Value<bool> smsOptIn,
      Value<String> status,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> firstName,
      Value<String> lastName,
      Value<String?> email,
      Value<String?> phone,
      Value<DateTime?> dateOfBirth,
      Value<String?> gender,
      Value<String?> address,
      Value<String?> city,
      Value<String?> state,
      Value<String?> zipCode,
      Value<int> loyaltyPoints,
      Value<DateTime?> lastVisit,
      Value<int?> preferredTechnicianId,
      Value<String?> notes,
      Value<String?> allergies,
      Value<bool> emailOptIn,
      Value<bool> smsOptIn,
      Value<String> status,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$PosDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _preferredTechnicianIdTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(
          db.customers.preferredTechnicianId,
          db.employees.id,
        ),
      );

  $$EmployeesTableProcessedTableManager? get preferredTechnicianId {
    final $_column = $_itemColumn<int>('preferred_technician_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _preferredTechnicianIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AppointmentsTable, List<Appointment>>
  _appointmentsRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.appointments,
    aliasName: $_aliasNameGenerator(
      db.customers.id,
      db.appointments.customerId,
    ),
  );

  $$AppointmentsTableProcessedTableManager get appointmentsRefs {
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_appointmentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TicketsTable, List<Ticket>> _ticketsRefsTable(
    _$PosDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tickets,
    aliasName: $_aliasNameGenerator(db.customers.id, db.tickets.customerId),
  );

  $$TicketsTableProcessedTableManager get ticketsRefs {
    final manager = $$TicketsTableTableManager(
      $_db,
      $_db.tickets,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ticketsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
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

  ColumnFilters<DateTime> get lastVisit => $composableBuilder(
    column: $table.lastVisit,
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

  ColumnFilters<bool> get emailOptIn => $composableBuilder(
    column: $table.emailOptIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get smsOptIn => $composableBuilder(
    column: $table.smsOptIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get preferredTechnicianId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preferredTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> appointmentsRefs(
    Expression<bool> Function($$AppointmentsTableFilterComposer f) f,
  ) {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ticketsRefs(
    Expression<bool> Function($$TicketsTableFilterComposer f) f,
  ) {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
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

  ColumnOrderings<DateTime> get lastVisit => $composableBuilder(
    column: $table.lastVisit,
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

  ColumnOrderings<bool> get emailOptIn => $composableBuilder(
    column: $table.emailOptIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get smsOptIn => $composableBuilder(
    column: $table.smsOptIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get preferredTechnicianId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preferredTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
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

  GeneratedColumn<DateTime> get lastVisit =>
      $composableBuilder(column: $table.lastVisit, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<bool> get emailOptIn => $composableBuilder(
    column: $table.emailOptIn,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get smsOptIn =>
      $composableBuilder(column: $table.smsOptIn, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get preferredTechnicianId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.preferredTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> appointmentsRefs<T extends Object>(
    Expression<T> Function($$AppointmentsTableAnnotationComposer a) f,
  ) {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ticketsRefs<T extends Object>(
    Expression<T> Function($$TicketsTableAnnotationComposer a) f,
  ) {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({
            bool preferredTechnicianId,
            bool appointmentsRefs,
            bool ticketsRefs,
          })
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
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> zipCode = const Value.absent(),
                Value<int> loyaltyPoints = const Value.absent(),
                Value<DateTime?> lastVisit = const Value.absent(),
                Value<int?> preferredTechnicianId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<bool> emailOptIn = const Value.absent(),
                Value<bool> smsOptIn = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
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
                preferredTechnicianId: preferredTechnicianId,
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
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> state = const Value.absent(),
                Value<String?> zipCode = const Value.absent(),
                Value<int> loyaltyPoints = const Value.absent(),
                Value<DateTime?> lastVisit = const Value.absent(),
                Value<int?> preferredTechnicianId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> allergies = const Value.absent(),
                Value<bool> emailOptIn = const Value.absent(),
                Value<bool> smsOptIn = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
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
                preferredTechnicianId: preferredTechnicianId,
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                preferredTechnicianId = false,
                appointmentsRefs = false,
                ticketsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (appointmentsRefs) db.appointments,
                    if (ticketsRefs) db.tickets,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (preferredTechnicianId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.preferredTechnicianId,
                                    referencedTable: $$CustomersTableReferences
                                        ._preferredTechnicianIdTable(db),
                                    referencedColumn: $$CustomersTableReferences
                                        ._preferredTechnicianIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (appointmentsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Appointment
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._appointmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ticketsRefs)
                        await $_getPrefetchedData<
                          Customer,
                          $CustomersTable,
                          Ticket
                        >(
                          currentTable: table,
                          referencedTable: $$CustomersTableReferences
                              ._ticketsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CustomersTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.customerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({
        bool preferredTechnicianId,
        bool appointmentsRefs,
        bool ticketsRefs,
      })
    >;
typedef $$ServicesTableCreateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required int categoryId,
      required int durationMinutes,
      required int basePriceCents,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$ServicesTableUpdateCompanionBuilder =
    ServicesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<int> categoryId,
      Value<int> durationMinutes,
      Value<int> basePriceCents,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ServicesTableReferences
    extends BaseReferences<_$PosDatabase, $ServicesTable, Service> {
  $$ServicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ServiceCategoriesTable _categoryIdTable(_$PosDatabase db) =>
      db.serviceCategories.createAlias(
        $_aliasNameGenerator(db.services.categoryId, db.serviceCategories.id),
      );

  $$ServiceCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$ServiceCategoriesTableTableManager(
      $_db,
      $_db.serviceCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TicketServicesTable, List<TicketService>>
  _ticketServicesRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.ticketServices,
    aliasName: $_aliasNameGenerator(
      db.services.id,
      db.ticketServices.serviceId,
    ),
  );

  $$TicketServicesTableProcessedTableManager get ticketServicesRefs {
    final manager = $$TicketServicesTableTableManager(
      $_db,
      $_db.ticketServices,
    ).filter((f) => f.serviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ticketServicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AppointmentServicesTable,
    List<AppointmentService>
  >
  _appointmentServicesRefsTable(_$PosDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.appointmentServices,
        aliasName: $_aliasNameGenerator(
          db.services.id,
          db.appointmentServices.serviceId,
        ),
      );

  $$AppointmentServicesTableProcessedTableManager get appointmentServicesRefs {
    final manager = $$AppointmentServicesTableTableManager(
      $_db,
      $_db.appointmentServices,
    ).filter((f) => f.serviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _appointmentServicesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get basePriceCents => $composableBuilder(
    column: $table.basePriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ServiceCategoriesTableFilterComposer get categoryId {
    final $$ServiceCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.serviceCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.serviceCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ticketServicesRefs(
    Expression<bool> Function($$TicketServicesTableFilterComposer f) f,
  ) {
    final $$TicketServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketServices,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketServicesTableFilterComposer(
            $db: $db,
            $table: $db.ticketServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appointmentServicesRefs(
    Expression<bool> Function($$AppointmentServicesTableFilterComposer f) f,
  ) {
    final $$AppointmentServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointmentServices,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentServicesTableFilterComposer(
            $db: $db,
            $table: $db.appointmentServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get basePriceCents => $composableBuilder(
    column: $table.basePriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ServiceCategoriesTableOrderingComposer get categoryId {
    final $$ServiceCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.serviceCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.serviceCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get basePriceCents => $composableBuilder(
    column: $table.basePriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ServiceCategoriesTableAnnotationComposer get categoryId {
    final $$ServiceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.serviceCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ServiceCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.serviceCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> ticketServicesRefs<T extends Object>(
    Expression<T> Function($$TicketServicesTableAnnotationComposer a) f,
  ) {
    final $$TicketServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketServices,
      getReferencedColumn: (t) => t.serviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.ticketServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> appointmentServicesRefs<T extends Object>(
    Expression<T> Function($$AppointmentServicesTableAnnotationComposer a) f,
  ) {
    final $$AppointmentServicesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.appointmentServices,
          getReferencedColumn: (t) => t.serviceId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AppointmentServicesTableAnnotationComposer(
                $db: $db,
                $table: $db.appointmentServices,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (Service, $$ServicesTableReferences),
          Service,
          PrefetchHooks Function({
            bool categoryId,
            bool ticketServicesRefs,
            bool appointmentServicesRefs,
          })
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
                Value<int> categoryId = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<int> basePriceCents = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ServicesCompanion(
                id: id,
                name: name,
                description: description,
                categoryId: categoryId,
                durationMinutes: durationMinutes,
                basePriceCents: basePriceCents,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required int categoryId,
                required int durationMinutes,
                required int basePriceCents,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => ServicesCompanion.insert(
                id: id,
                name: name,
                description: description,
                categoryId: categoryId,
                durationMinutes: durationMinutes,
                basePriceCents: basePriceCents,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                ticketServicesRefs = false,
                appointmentServicesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ticketServicesRefs) db.ticketServices,
                    if (appointmentServicesRefs) db.appointmentServices,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ServicesTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ServicesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ticketServicesRefs)
                        await $_getPrefetchedData<
                          Service,
                          $ServicesTable,
                          TicketService
                        >(
                          currentTable: table,
                          referencedTable: $$ServicesTableReferences
                              ._ticketServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServicesTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (appointmentServicesRefs)
                        await $_getPrefetchedData<
                          Service,
                          $ServicesTable,
                          AppointmentService
                        >(
                          currentTable: table,
                          referencedTable: $$ServicesTableReferences
                              ._appointmentServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ServicesTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.serviceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (Service, $$ServicesTableReferences),
      Service,
      PrefetchHooks Function({
        bool categoryId,
        bool ticketServicesRefs,
        bool appointmentServicesRefs,
      })
    >;
typedef $$EmployeeServiceCategoriesTableCreateCompanionBuilder =
    EmployeeServiceCategoriesCompanion Function({
      required int employeeId,
      required int categoryId,
      Value<DateTime?> certifiedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$EmployeeServiceCategoriesTableUpdateCompanionBuilder =
    EmployeeServiceCategoriesCompanion Function({
      Value<int> employeeId,
      Value<int> categoryId,
      Value<DateTime?> certifiedAt,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$EmployeeServiceCategoriesTableReferences
    extends
        BaseReferences<
          _$PosDatabase,
          $EmployeeServiceCategoriesTable,
          EmployeeServiceCategory
        > {
  $$EmployeeServiceCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmployeesTable _employeeIdTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(
          db.employeeServiceCategories.employeeId,
          db.employees.id,
        ),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServiceCategoriesTable _categoryIdTable(_$PosDatabase db) =>
      db.serviceCategories.createAlias(
        $_aliasNameGenerator(
          db.employeeServiceCategories.categoryId,
          db.serviceCategories.id,
        ),
      );

  $$ServiceCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$ServiceCategoriesTableTableManager(
      $_db,
      $_db.serviceCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EmployeeServiceCategoriesTableFilterComposer
    extends Composer<_$PosDatabase, $EmployeeServiceCategoriesTable> {
  $$EmployeeServiceCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get certifiedAt => $composableBuilder(
    column: $table.certifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceCategoriesTableFilterComposer get categoryId {
    final $$ServiceCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.serviceCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.serviceCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
  ColumnOrderings<DateTime> get certifiedAt => $composableBuilder(
    column: $table.certifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceCategoriesTableOrderingComposer get categoryId {
    final $$ServiceCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.serviceCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServiceCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.serviceCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
  GeneratedColumn<DateTime> get certifiedAt => $composableBuilder(
    column: $table.certifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServiceCategoriesTableAnnotationComposer get categoryId {
    final $$ServiceCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.serviceCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ServiceCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.serviceCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
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
          (EmployeeServiceCategory, $$EmployeeServiceCategoriesTableReferences),
          EmployeeServiceCategory,
          PrefetchHooks Function({bool employeeId, bool categoryId})
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
                Value<int> employeeId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<DateTime?> certifiedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeeServiceCategoriesCompanion(
                employeeId: employeeId,
                categoryId: categoryId,
                certifiedAt: certifiedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int employeeId,
                required int categoryId,
                Value<DateTime?> certifiedAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeeServiceCategoriesCompanion.insert(
                employeeId: employeeId,
                categoryId: categoryId,
                certifiedAt: certifiedAt,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeeServiceCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable:
                                    $$EmployeeServiceCategoriesTableReferences
                                        ._employeeIdTable(db),
                                referencedColumn:
                                    $$EmployeeServiceCategoriesTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (categoryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.categoryId,
                                referencedTable:
                                    $$EmployeeServiceCategoriesTableReferences
                                        ._categoryIdTable(db),
                                referencedColumn:
                                    $$EmployeeServiceCategoriesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (EmployeeServiceCategory, $$EmployeeServiceCategoriesTableReferences),
      EmployeeServiceCategory,
      PrefetchHooks Function({bool employeeId, bool categoryId})
    >;
typedef $$AppointmentsTableCreateCompanionBuilder =
    AppointmentsCompanion Function({
      required String id,
      required String customerId,
      required int employeeId,
      required DateTime startDateTime,
      required DateTime endDateTime,
      required List<Map<String, Object?>> services,
      Value<String> status,
      Value<String?> notes,
      Value<bool> isGroupBooking,
      Value<int?> groupSize,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int?> lastModifiedBy,
      Value<String?> lastModifiedDevice,
      Value<DateTime?> confirmedAt,
      Value<String?> confirmationType,
      Value<int> rowid,
    });
typedef $$AppointmentsTableUpdateCompanionBuilder =
    AppointmentsCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<int> employeeId,
      Value<DateTime> startDateTime,
      Value<DateTime> endDateTime,
      Value<List<Map<String, Object?>>> services,
      Value<String> status,
      Value<String?> notes,
      Value<bool> isGroupBooking,
      Value<int?> groupSize,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int?> lastModifiedBy,
      Value<String?> lastModifiedDevice,
      Value<DateTime?> confirmedAt,
      Value<String?> confirmationType,
      Value<int> rowid,
    });

final class $$AppointmentsTableReferences
    extends BaseReferences<_$PosDatabase, $AppointmentsTable, Appointment> {
  $$AppointmentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$PosDatabase db) =>
      db.customers.createAlias(
        $_aliasNameGenerator(db.appointments.customerId, db.customers.id),
      );

  $$CustomersTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _employeeIdTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.appointments.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _lastModifiedByTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.appointments.lastModifiedBy, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager? get lastModifiedBy {
    final $_column = $_itemColumn<int>('last_modified_by');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lastModifiedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TicketsTable, List<Ticket>> _ticketsRefsTable(
    _$PosDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tickets,
    aliasName: $_aliasNameGenerator(
      db.appointments.id,
      db.tickets.appointmentId,
    ),
  );

  $$TicketsTableProcessedTableManager get ticketsRefs {
    final manager = $$TicketsTableTableManager(
      $_db,
      $_db.tickets,
    ).filter((f) => f.appointmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ticketsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $AppointmentServicesTable,
    List<AppointmentService>
  >
  _appointmentServicesRefsTable(_$PosDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.appointmentServices,
        aliasName: $_aliasNameGenerator(
          db.appointments.id,
          db.appointmentServices.appointmentId,
        ),
      );

  $$AppointmentServicesTableProcessedTableManager get appointmentServicesRefs {
    final manager = $$AppointmentServicesTableTableManager(
      $_db,
      $_db.appointmentServices,
    ).filter((f) => f.appointmentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _appointmentServicesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<Map<String, Object?>>,
    List<Map<String, Object>>,
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

  ColumnFilters<bool> get isGroupBooking => $composableBuilder(
    column: $table.isGroupBooking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get groupSize => $composableBuilder(
    column: $table.groupSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastModifiedDevice => $composableBuilder(
    column: $table.lastModifiedDevice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmationType => $composableBuilder(
    column: $table.confirmationType,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get lastModifiedBy {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastModifiedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ticketsRefs(
    Expression<bool> Function($$TicketsTableFilterComposer f) f,
  ) {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.appointmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> appointmentServicesRefs(
    Expression<bool> Function($$AppointmentServicesTableFilterComposer f) f,
  ) {
    final $$AppointmentServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.appointmentServices,
      getReferencedColumn: (t) => t.appointmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentServicesTableFilterComposer(
            $db: $db,
            $table: $db.appointmentServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
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

  ColumnOrderings<bool> get isGroupBooking => $composableBuilder(
    column: $table.isGroupBooking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get groupSize => $composableBuilder(
    column: $table.groupSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastModifiedDevice => $composableBuilder(
    column: $table.lastModifiedDevice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmationType => $composableBuilder(
    column: $table.confirmationType,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get lastModifiedBy {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastModifiedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<DateTime> get startDateTime => $composableBuilder(
    column: $table.startDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endDateTime => $composableBuilder(
    column: $table.endDateTime,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Map<String, Object?>>, String>
  get services =>
      $composableBuilder(column: $table.services, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isGroupBooking => $composableBuilder(
    column: $table.isGroupBooking,
    builder: (column) => column,
  );

  GeneratedColumn<int> get groupSize =>
      $composableBuilder(column: $table.groupSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get lastModifiedDevice => $composableBuilder(
    column: $table.lastModifiedDevice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confirmationType => $composableBuilder(
    column: $table.confirmationType,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get lastModifiedBy {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lastModifiedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ticketsRefs<T extends Object>(
    Expression<T> Function($$TicketsTableAnnotationComposer a) f,
  ) {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.appointmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> appointmentServicesRefs<T extends Object>(
    Expression<T> Function($$AppointmentServicesTableAnnotationComposer a) f,
  ) {
    final $$AppointmentServicesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.appointmentServices,
          getReferencedColumn: (t) => t.appointmentId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$AppointmentServicesTableAnnotationComposer(
                $db: $db,
                $table: $db.appointmentServices,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (Appointment, $$AppointmentsTableReferences),
          Appointment,
          PrefetchHooks Function({
            bool customerId,
            bool employeeId,
            bool lastModifiedBy,
            bool ticketsRefs,
            bool appointmentServicesRefs,
          })
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
                Value<DateTime> startDateTime = const Value.absent(),
                Value<DateTime> endDateTime = const Value.absent(),
                Value<List<Map<String, Object?>>> services =
                    const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isGroupBooking = const Value.absent(),
                Value<int?> groupSize = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int?> lastModifiedBy = const Value.absent(),
                Value<String?> lastModifiedDevice = const Value.absent(),
                Value<DateTime?> confirmedAt = const Value.absent(),
                Value<String?> confirmationType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppointmentsCompanion(
                id: id,
                customerId: customerId,
                employeeId: employeeId,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
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
                required DateTime startDateTime,
                required DateTime endDateTime,
                required List<Map<String, Object?>> services,
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isGroupBooking = const Value.absent(),
                Value<int?> groupSize = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int?> lastModifiedBy = const Value.absent(),
                Value<String?> lastModifiedDevice = const Value.absent(),
                Value<DateTime?> confirmedAt = const Value.absent(),
                Value<String?> confirmationType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppointmentsCompanion.insert(
                id: id,
                customerId: customerId,
                employeeId: employeeId,
                startDateTime: startDateTime,
                endDateTime: endDateTime,
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$AppointmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                employeeId = false,
                lastModifiedBy = false,
                ticketsRefs = false,
                appointmentServicesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ticketsRefs) db.tickets,
                    if (appointmentServicesRefs) db.appointmentServices,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable:
                                        $$AppointmentsTableReferences
                                            ._customerIdTable(db),
                                    referencedColumn:
                                        $$AppointmentsTableReferences
                                            ._customerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (employeeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.employeeId,
                                    referencedTable:
                                        $$AppointmentsTableReferences
                                            ._employeeIdTable(db),
                                    referencedColumn:
                                        $$AppointmentsTableReferences
                                            ._employeeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (lastModifiedBy) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.lastModifiedBy,
                                    referencedTable:
                                        $$AppointmentsTableReferences
                                            ._lastModifiedByTable(db),
                                    referencedColumn:
                                        $$AppointmentsTableReferences
                                            ._lastModifiedByTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ticketsRefs)
                        await $_getPrefetchedData<
                          Appointment,
                          $AppointmentsTable,
                          Ticket
                        >(
                          currentTable: table,
                          referencedTable: $$AppointmentsTableReferences
                              ._ticketsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AppointmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.appointmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (appointmentServicesRefs)
                        await $_getPrefetchedData<
                          Appointment,
                          $AppointmentsTable,
                          AppointmentService
                        >(
                          currentTable: table,
                          referencedTable: $$AppointmentsTableReferences
                              ._appointmentServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AppointmentsTableReferences(
                                db,
                                table,
                                p0,
                              ).appointmentServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.appointmentId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (Appointment, $$AppointmentsTableReferences),
      Appointment,
      PrefetchHooks Function({
        bool customerId,
        bool employeeId,
        bool lastModifiedBy,
        bool ticketsRefs,
        bool appointmentServicesRefs,
      })
    >;
typedef $$TicketsTableCreateCompanionBuilder =
    TicketsCompanion Function({
      required String id,
      Value<String?> customerId,
      required int employeeId,
      required int ticketNumber,
      required String customerName,
      Value<int> priority,
      Value<String?> notes,
      Value<String> status,
      required DateTime createdAt,
      required DateTime updatedAt,
      required DateTime businessDate,
      Value<DateTime?> checkInTime,
      Value<int?> assignedTechnicianId,
      Value<int?> totalAmountCents,
      Value<String> paymentStatus,
      Value<bool> isGroupService,
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
      Value<int> priority,
      Value<String?> notes,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime> businessDate,
      Value<DateTime?> checkInTime,
      Value<int?> assignedTechnicianId,
      Value<int?> totalAmountCents,
      Value<String> paymentStatus,
      Value<bool> isGroupService,
      Value<int?> groupSize,
      Value<String?> appointmentId,
      Value<int> rowid,
    });

final class $$TicketsTableReferences
    extends BaseReferences<_$PosDatabase, $TicketsTable, Ticket> {
  $$TicketsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$PosDatabase db) =>
      db.customers.createAlias(
        $_aliasNameGenerator(db.tickets.customerId, db.customers.id),
      );

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _employeeIdTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.tickets.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _assignedTechnicianIdTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.tickets.assignedTechnicianId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager? get assignedTechnicianId {
    final $_column = $_itemColumn<int>('assigned_technician_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _assignedTechnicianIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AppointmentsTable _appointmentIdTable(_$PosDatabase db) =>
      db.appointments.createAlias(
        $_aliasNameGenerator(db.tickets.appointmentId, db.appointments.id),
      );

  $$AppointmentsTableProcessedTableManager? get appointmentId {
    final $_column = $_itemColumn<String>('appointment_id');
    if ($_column == null) return null;
    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appointmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TicketServicesTable, List<TicketService>>
  _ticketServicesRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.ticketServices,
    aliasName: $_aliasNameGenerator(db.tickets.id, db.ticketServices.ticketId),
  );

  $$TicketServicesTableProcessedTableManager get ticketServicesRefs {
    final manager = $$TicketServicesTableTableManager(
      $_db,
      $_db.ticketServices,
    ).filter((f) => f.ticketId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ticketServicesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InvoiceTicketsTable, List<InvoiceTicket>>
  _invoiceTicketsRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceTickets,
    aliasName: $_aliasNameGenerator(db.tickets.id, db.invoiceTickets.ticketId),
  );

  $$InvoiceTicketsTableProcessedTableManager get invoiceTicketsRefs {
    final manager = $$InvoiceTicketsTableTableManager(
      $_db,
      $_db.invoiceTickets,
    ).filter((f) => f.ticketId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceTicketsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$PosDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.tickets.id, db.payments.ticketId),
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.ticketId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<int> get ticketNumber => $composableBuilder(
    column: $table.ticketNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get businessDate => $composableBuilder(
    column: $table.businessDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isGroupService => $composableBuilder(
    column: $table.isGroupService,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get groupSize => $composableBuilder(
    column: $table.groupSize,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get assignedTechnicianId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AppointmentsTableFilterComposer get appointmentId {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ticketServicesRefs(
    Expression<bool> Function($$TicketServicesTableFilterComposer f) f,
  ) {
    final $$TicketServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketServices,
      getReferencedColumn: (t) => t.ticketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketServicesTableFilterComposer(
            $db: $db,
            $table: $db.ticketServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> invoiceTicketsRefs(
    Expression<bool> Function($$InvoiceTicketsTableFilterComposer f) f,
  ) {
    final $$InvoiceTicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceTickets,
      getReferencedColumn: (t) => t.ticketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceTicketsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceTickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.ticketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<int> get ticketNumber => $composableBuilder(
    column: $table.ticketNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get businessDate => $composableBuilder(
    column: $table.businessDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isGroupService => $composableBuilder(
    column: $table.isGroupService,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get groupSize => $composableBuilder(
    column: $table.groupSize,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get assignedTechnicianId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AppointmentsTableOrderingComposer get appointmentId {
    final $$AppointmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableOrderingComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<int> get ticketNumber => $composableBuilder(
    column: $table.ticketNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get businessDate => $composableBuilder(
    column: $table.businessDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get checkInTime => $composableBuilder(
    column: $table.checkInTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isGroupService => $composableBuilder(
    column: $table.isGroupService,
    builder: (column) => column,
  );

  GeneratedColumn<int> get groupSize =>
      $composableBuilder(column: $table.groupSize, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get assignedTechnicianId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AppointmentsTableAnnotationComposer get appointmentId {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ticketServicesRefs<T extends Object>(
    Expression<T> Function($$TicketServicesTableAnnotationComposer a) f,
  ) {
    final $$TicketServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ticketServices,
      getReferencedColumn: (t) => t.ticketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.ticketServices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> invoiceTicketsRefs<T extends Object>(
    Expression<T> Function($$InvoiceTicketsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceTicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceTickets,
      getReferencedColumn: (t) => t.ticketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceTicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceTickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.ticketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Ticket, $$TicketsTableReferences),
          Ticket,
          PrefetchHooks Function({
            bool customerId,
            bool employeeId,
            bool assignedTechnicianId,
            bool appointmentId,
            bool ticketServicesRefs,
            bool invoiceTicketsRefs,
            bool paymentsRefs,
          })
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
                Value<int> priority = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> businessDate = const Value.absent(),
                Value<DateTime?> checkInTime = const Value.absent(),
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<int?> totalAmountCents = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<bool> isGroupService = const Value.absent(),
                Value<int?> groupSize = const Value.absent(),
                Value<String?> appointmentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketsCompanion(
                id: id,
                customerId: customerId,
                employeeId: employeeId,
                ticketNumber: ticketNumber,
                customerName: customerName,
                priority: priority,
                notes: notes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                businessDate: businessDate,
                checkInTime: checkInTime,
                assignedTechnicianId: assignedTechnicianId,
                totalAmountCents: totalAmountCents,
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
                Value<int> priority = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                required DateTime businessDate,
                Value<DateTime?> checkInTime = const Value.absent(),
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<int?> totalAmountCents = const Value.absent(),
                Value<String> paymentStatus = const Value.absent(),
                Value<bool> isGroupService = const Value.absent(),
                Value<int?> groupSize = const Value.absent(),
                Value<String?> appointmentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketsCompanion.insert(
                id: id,
                customerId: customerId,
                employeeId: employeeId,
                ticketNumber: ticketNumber,
                customerName: customerName,
                priority: priority,
                notes: notes,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                businessDate: businessDate,
                checkInTime: checkInTime,
                assignedTechnicianId: assignedTechnicianId,
                totalAmountCents: totalAmountCents,
                paymentStatus: paymentStatus,
                isGroupService: isGroupService,
                groupSize: groupSize,
                appointmentId: appointmentId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TicketsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                customerId = false,
                employeeId = false,
                assignedTechnicianId = false,
                appointmentId = false,
                ticketServicesRefs = false,
                invoiceTicketsRefs = false,
                paymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ticketServicesRefs) db.ticketServices,
                    if (invoiceTicketsRefs) db.invoiceTickets,
                    if (paymentsRefs) db.payments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$TicketsTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$TicketsTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (employeeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.employeeId,
                                    referencedTable: $$TicketsTableReferences
                                        ._employeeIdTable(db),
                                    referencedColumn: $$TicketsTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (assignedTechnicianId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.assignedTechnicianId,
                                    referencedTable: $$TicketsTableReferences
                                        ._assignedTechnicianIdTable(db),
                                    referencedColumn: $$TicketsTableReferences
                                        ._assignedTechnicianIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (appointmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.appointmentId,
                                    referencedTable: $$TicketsTableReferences
                                        ._appointmentIdTable(db),
                                    referencedColumn: $$TicketsTableReferences
                                        ._appointmentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ticketServicesRefs)
                        await $_getPrefetchedData<
                          Ticket,
                          $TicketsTable,
                          TicketService
                        >(
                          currentTable: table,
                          referencedTable: $$TicketsTableReferences
                              ._ticketServicesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TicketsTableReferences(
                                db,
                                table,
                                p0,
                              ).ticketServicesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ticketId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (invoiceTicketsRefs)
                        await $_getPrefetchedData<
                          Ticket,
                          $TicketsTable,
                          InvoiceTicket
                        >(
                          currentTable: table,
                          referencedTable: $$TicketsTableReferences
                              ._invoiceTicketsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TicketsTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceTicketsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ticketId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          Ticket,
                          $TicketsTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$TicketsTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TicketsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ticketId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (Ticket, $$TicketsTableReferences),
      Ticket,
      PrefetchHooks Function({
        bool customerId,
        bool employeeId,
        bool assignedTechnicianId,
        bool appointmentId,
        bool ticketServicesRefs,
        bool invoiceTicketsRefs,
        bool paymentsRefs,
      })
    >;
typedef $$TicketServicesTableCreateCompanionBuilder =
    TicketServicesCompanion Function({
      required String id,
      required String ticketId,
      required int serviceId,
      Value<int> quantity,
      required int unitPriceCents,
      required int totalPriceCents,
      Value<String> status,
      Value<int?> assignedTechnicianId,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TicketServicesTableUpdateCompanionBuilder =
    TicketServicesCompanion Function({
      Value<String> id,
      Value<String> ticketId,
      Value<int> serviceId,
      Value<int> quantity,
      Value<int> unitPriceCents,
      Value<int> totalPriceCents,
      Value<String> status,
      Value<int?> assignedTechnicianId,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TicketServicesTableReferences
    extends BaseReferences<_$PosDatabase, $TicketServicesTable, TicketService> {
  $$TicketServicesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TicketsTable _ticketIdTable(_$PosDatabase db) =>
      db.tickets.createAlias(
        $_aliasNameGenerator(db.ticketServices.ticketId, db.tickets.id),
      );

  $$TicketsTableProcessedTableManager get ticketId {
    final $_column = $_itemColumn<String>('ticket_id')!;

    final manager = $$TicketsTableTableManager(
      $_db,
      $_db.tickets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ticketIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServicesTable _serviceIdTable(_$PosDatabase db) =>
      db.services.createAlias(
        $_aliasNameGenerator(db.ticketServices.serviceId, db.services.id),
      );

  $$ServicesTableProcessedTableManager get serviceId {
    final $_column = $_itemColumn<int>('service_id')!;

    final manager = $$ServicesTableTableManager(
      $_db,
      $_db.services,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _assignedTechnicianIdTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(
          db.ticketServices.assignedTechnicianId,
          db.employees.id,
        ),
      );

  $$EmployeesTableProcessedTableManager? get assignedTechnicianId {
    final $_column = $_itemColumn<int>('assigned_technician_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _assignedTechnicianIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TicketServicesTableFilterComposer
    extends Composer<_$PosDatabase, $TicketServicesTable> {
  $$TicketServicesTableFilterComposer({
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

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPriceCents => $composableBuilder(
    column: $table.totalPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TicketsTableFilterComposer get ticketId {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableFilterComposer get serviceId {
    final $$ServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableFilterComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get assignedTechnicianId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketServicesTableOrderingComposer
    extends Composer<_$PosDatabase, $TicketServicesTable> {
  $$TicketServicesTableOrderingComposer({
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

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPriceCents => $composableBuilder(
    column: $table.totalPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TicketsTableOrderingComposer get ticketId {
    final $$TicketsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableOrderingComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableOrderingComposer get serviceId {
    final $$ServicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableOrderingComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get assignedTechnicianId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketServicesTableAnnotationComposer
    extends Composer<_$PosDatabase, $TicketServicesTable> {
  $$TicketServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPriceCents => $composableBuilder(
    column: $table.totalPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TicketsTableAnnotationComposer get ticketId {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableAnnotationComposer get serviceId {
    final $$ServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get assignedTechnicianId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TicketServicesTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $TicketServicesTable,
          TicketService,
          $$TicketServicesTableFilterComposer,
          $$TicketServicesTableOrderingComposer,
          $$TicketServicesTableAnnotationComposer,
          $$TicketServicesTableCreateCompanionBuilder,
          $$TicketServicesTableUpdateCompanionBuilder,
          (TicketService, $$TicketServicesTableReferences),
          TicketService,
          PrefetchHooks Function({
            bool ticketId,
            bool serviceId,
            bool assignedTechnicianId,
          })
        > {
  $$TicketServicesTableTableManager(
    _$PosDatabase db,
    $TicketServicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TicketServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TicketServicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TicketServicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ticketId = const Value.absent(),
                Value<int> serviceId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPriceCents = const Value.absent(),
                Value<int> totalPriceCents = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TicketServicesCompanion(
                id: id,
                ticketId: ticketId,
                serviceId: serviceId,
                quantity: quantity,
                unitPriceCents: unitPriceCents,
                totalPriceCents: totalPriceCents,
                status: status,
                assignedTechnicianId: assignedTechnicianId,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ticketId,
                required int serviceId,
                Value<int> quantity = const Value.absent(),
                required int unitPriceCents,
                required int totalPriceCents,
                Value<String> status = const Value.absent(),
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TicketServicesCompanion.insert(
                id: id,
                ticketId: ticketId,
                serviceId: serviceId,
                quantity: quantity,
                unitPriceCents: unitPriceCents,
                totalPriceCents: totalPriceCents,
                status: status,
                assignedTechnicianId: assignedTechnicianId,
                startedAt: startedAt,
                completedAt: completedAt,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TicketServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ticketId = false,
                serviceId = false,
                assignedTechnicianId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ticketId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ticketId,
                                    referencedTable:
                                        $$TicketServicesTableReferences
                                            ._ticketIdTable(db),
                                    referencedColumn:
                                        $$TicketServicesTableReferences
                                            ._ticketIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (serviceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.serviceId,
                                    referencedTable:
                                        $$TicketServicesTableReferences
                                            ._serviceIdTable(db),
                                    referencedColumn:
                                        $$TicketServicesTableReferences
                                            ._serviceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (assignedTechnicianId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.assignedTechnicianId,
                                    referencedTable:
                                        $$TicketServicesTableReferences
                                            ._assignedTechnicianIdTable(db),
                                    referencedColumn:
                                        $$TicketServicesTableReferences
                                            ._assignedTechnicianIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TicketServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $TicketServicesTable,
      TicketService,
      $$TicketServicesTableFilterComposer,
      $$TicketServicesTableOrderingComposer,
      $$TicketServicesTableAnnotationComposer,
      $$TicketServicesTableCreateCompanionBuilder,
      $$TicketServicesTableUpdateCompanionBuilder,
      (TicketService, $$TicketServicesTableReferences),
      TicketService,
      PrefetchHooks Function({
        bool ticketId,
        bool serviceId,
        bool assignedTechnicianId,
      })
    >;
typedef $$AppointmentServicesTableCreateCompanionBuilder =
    AppointmentServicesCompanion Function({
      required String id,
      required String appointmentId,
      required int serviceId,
      Value<int> quantity,
      required int unitPriceCents,
      required int totalPriceCents,
      Value<String> status,
      Value<int?> assignedTechnicianId,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AppointmentServicesTableUpdateCompanionBuilder =
    AppointmentServicesCompanion Function({
      Value<String> id,
      Value<String> appointmentId,
      Value<int> serviceId,
      Value<int> quantity,
      Value<int> unitPriceCents,
      Value<int> totalPriceCents,
      Value<String> status,
      Value<int?> assignedTechnicianId,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$AppointmentServicesTableReferences
    extends
        BaseReferences<
          _$PosDatabase,
          $AppointmentServicesTable,
          AppointmentService
        > {
  $$AppointmentServicesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AppointmentsTable _appointmentIdTable(_$PosDatabase db) =>
      db.appointments.createAlias(
        $_aliasNameGenerator(
          db.appointmentServices.appointmentId,
          db.appointments.id,
        ),
      );

  $$AppointmentsTableProcessedTableManager get appointmentId {
    final $_column = $_itemColumn<String>('appointment_id')!;

    final manager = $$AppointmentsTableTableManager(
      $_db,
      $_db.appointments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_appointmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ServicesTable _serviceIdTable(_$PosDatabase db) =>
      db.services.createAlias(
        $_aliasNameGenerator(db.appointmentServices.serviceId, db.services.id),
      );

  $$ServicesTableProcessedTableManager get serviceId {
    final $_column = $_itemColumn<int>('service_id')!;

    final manager = $$ServicesTableTableManager(
      $_db,
      $_db.services,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_serviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _assignedTechnicianIdTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(
          db.appointmentServices.assignedTechnicianId,
          db.employees.id,
        ),
      );

  $$EmployeesTableProcessedTableManager? get assignedTechnicianId {
    final $_column = $_itemColumn<int>('assigned_technician_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _assignedTechnicianIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AppointmentServicesTableFilterComposer
    extends Composer<_$PosDatabase, $AppointmentServicesTable> {
  $$AppointmentServicesTableFilterComposer({
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

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPriceCents => $composableBuilder(
    column: $table.totalPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AppointmentsTableFilterComposer get appointmentId {
    final $$AppointmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableFilterComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableFilterComposer get serviceId {
    final $$ServicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableFilterComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get assignedTechnicianId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentServicesTableOrderingComposer
    extends Composer<_$PosDatabase, $AppointmentServicesTable> {
  $$AppointmentServicesTableOrderingComposer({
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

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPriceCents => $composableBuilder(
    column: $table.totalPriceCents,
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

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AppointmentsTableOrderingComposer get appointmentId {
    final $$AppointmentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableOrderingComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableOrderingComposer get serviceId {
    final $$ServicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableOrderingComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get assignedTechnicianId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentServicesTableAnnotationComposer
    extends Composer<_$PosDatabase, $AppointmentServicesTable> {
  $$AppointmentServicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceCents => $composableBuilder(
    column: $table.unitPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalPriceCents => $composableBuilder(
    column: $table.totalPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AppointmentsTableAnnotationComposer get appointmentId {
    final $$AppointmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.appointmentId,
      referencedTable: $db.appointments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AppointmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.appointments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ServicesTableAnnotationComposer get serviceId {
    final $$ServicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.serviceId,
      referencedTable: $db.services,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicesTableAnnotationComposer(
            $db: $db,
            $table: $db.services,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get assignedTechnicianId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.assignedTechnicianId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AppointmentServicesTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $AppointmentServicesTable,
          AppointmentService,
          $$AppointmentServicesTableFilterComposer,
          $$AppointmentServicesTableOrderingComposer,
          $$AppointmentServicesTableAnnotationComposer,
          $$AppointmentServicesTableCreateCompanionBuilder,
          $$AppointmentServicesTableUpdateCompanionBuilder,
          (AppointmentService, $$AppointmentServicesTableReferences),
          AppointmentService,
          PrefetchHooks Function({
            bool appointmentId,
            bool serviceId,
            bool assignedTechnicianId,
          })
        > {
  $$AppointmentServicesTableTableManager(
    _$PosDatabase db,
    $AppointmentServicesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppointmentServicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppointmentServicesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AppointmentServicesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> appointmentId = const Value.absent(),
                Value<int> serviceId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPriceCents = const Value.absent(),
                Value<int> totalPriceCents = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppointmentServicesCompanion(
                id: id,
                appointmentId: appointmentId,
                serviceId: serviceId,
                quantity: quantity,
                unitPriceCents: unitPriceCents,
                totalPriceCents: totalPriceCents,
                status: status,
                assignedTechnicianId: assignedTechnicianId,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String appointmentId,
                required int serviceId,
                Value<int> quantity = const Value.absent(),
                required int unitPriceCents,
                required int totalPriceCents,
                Value<String> status = const Value.absent(),
                Value<int?> assignedTechnicianId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AppointmentServicesCompanion.insert(
                id: id,
                appointmentId: appointmentId,
                serviceId: serviceId,
                quantity: quantity,
                unitPriceCents: unitPriceCents,
                totalPriceCents: totalPriceCents,
                status: status,
                assignedTechnicianId: assignedTechnicianId,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AppointmentServicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                appointmentId = false,
                serviceId = false,
                assignedTechnicianId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (appointmentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.appointmentId,
                                    referencedTable:
                                        $$AppointmentServicesTableReferences
                                            ._appointmentIdTable(db),
                                    referencedColumn:
                                        $$AppointmentServicesTableReferences
                                            ._appointmentIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (serviceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.serviceId,
                                    referencedTable:
                                        $$AppointmentServicesTableReferences
                                            ._serviceIdTable(db),
                                    referencedColumn:
                                        $$AppointmentServicesTableReferences
                                            ._serviceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (assignedTechnicianId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.assignedTechnicianId,
                                    referencedTable:
                                        $$AppointmentServicesTableReferences
                                            ._assignedTechnicianIdTable(db),
                                    referencedColumn:
                                        $$AppointmentServicesTableReferences
                                            ._assignedTechnicianIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$AppointmentServicesTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $AppointmentServicesTable,
      AppointmentService,
      $$AppointmentServicesTableFilterComposer,
      $$AppointmentServicesTableOrderingComposer,
      $$AppointmentServicesTableAnnotationComposer,
      $$AppointmentServicesTableCreateCompanionBuilder,
      $$AppointmentServicesTableUpdateCompanionBuilder,
      (AppointmentService, $$AppointmentServicesTableReferences),
      AppointmentService,
      PrefetchHooks Function({
        bool appointmentId,
        bool serviceId,
        bool assignedTechnicianId,
      })
    >;
typedef $$InvoicesTableCreateCompanionBuilder =
    InvoicesCompanion Function({
      required String id,
      required String invoiceNumber,
      Value<String?> customerName,
      required int subtotalCents,
      required int taxAmountCents,
      required int tipAmountCents,
      required int discountAmountCents,
      required int totalAmountCents,
      required String paymentMethod,
      Value<String?> discountType,
      Value<String?> discountCode,
      Value<String?> discountReason,
      Value<String?> cardType,
      Value<String?> lastFourDigits,
      Value<String?> transactionId,
      Value<String?> authorizationCode,
      required DateTime processedAt,
      required int processedBy,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$InvoicesTableUpdateCompanionBuilder =
    InvoicesCompanion Function({
      Value<String> id,
      Value<String> invoiceNumber,
      Value<String?> customerName,
      Value<int> subtotalCents,
      Value<int> taxAmountCents,
      Value<int> tipAmountCents,
      Value<int> discountAmountCents,
      Value<int> totalAmountCents,
      Value<String> paymentMethod,
      Value<String?> discountType,
      Value<String?> discountCode,
      Value<String?> discountReason,
      Value<String?> cardType,
      Value<String?> lastFourDigits,
      Value<String?> transactionId,
      Value<String?> authorizationCode,
      Value<DateTime> processedAt,
      Value<int> processedBy,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$InvoicesTableReferences
    extends BaseReferences<_$PosDatabase, $InvoicesTable, Invoice> {
  $$InvoicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _processedByTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.invoices.processedBy, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get processedBy {
    final $_column = $_itemColumn<int>('processed_by')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_processedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InvoiceTicketsTable, List<InvoiceTicket>>
  _invoiceTicketsRefsTable(_$PosDatabase db) => MultiTypedResultKey.fromTable(
    db.invoiceTickets,
    aliasName: $_aliasNameGenerator(
      db.invoices.id,
      db.invoiceTickets.invoiceId,
    ),
  );

  $$InvoiceTicketsTableProcessedTableManager get invoiceTicketsRefs {
    final manager = $$InvoiceTicketsTableTableManager(
      $_db,
      $_db.invoiceTickets,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_invoiceTicketsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
    _$PosDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payments,
    aliasName: $_aliasNameGenerator(db.invoices.id, db.payments.invoiceId),
  );

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager(
      $_db,
      $_db.payments,
    ).filter((f) => f.invoiceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotalCents => $composableBuilder(
    column: $table.subtotalCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxAmountCents => $composableBuilder(
    column: $table.taxAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tipAmountCents => $composableBuilder(
    column: $table.tipAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountAmountCents => $composableBuilder(
    column: $table.discountAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
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

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get processedBy {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.processedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> invoiceTicketsRefs(
    Expression<bool> Function($$InvoiceTicketsTableFilterComposer f) f,
  ) {
    final $$InvoiceTicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceTickets,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceTicketsTableFilterComposer(
            $db: $db,
            $table: $db.invoiceTickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> paymentsRefs(
    Expression<bool> Function($$PaymentsTableFilterComposer f) f,
  ) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableFilterComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotalCents => $composableBuilder(
    column: $table.subtotalCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxAmountCents => $composableBuilder(
    column: $table.taxAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipAmountCents => $composableBuilder(
    column: $table.tipAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountAmountCents => $composableBuilder(
    column: $table.discountAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
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

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get processedBy {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.processedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotalCents => $composableBuilder(
    column: $table.subtotalCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxAmountCents => $composableBuilder(
    column: $table.taxAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tipAmountCents => $composableBuilder(
    column: $table.tipAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountAmountCents => $composableBuilder(
    column: $table.discountAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
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

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get processedBy {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.processedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> invoiceTicketsRefs<T extends Object>(
    Expression<T> Function($$InvoiceTicketsTableAnnotationComposer a) f,
  ) {
    final $$InvoiceTicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.invoiceTickets,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoiceTicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.invoiceTickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
    Expression<T> Function($$PaymentsTableAnnotationComposer a) f,
  ) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payments,
      getReferencedColumn: (t) => t.invoiceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.payments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (Invoice, $$InvoicesTableReferences),
          Invoice,
          PrefetchHooks Function({
            bool processedBy,
            bool invoiceTicketsRefs,
            bool paymentsRefs,
          })
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
                Value<String?> customerName = const Value.absent(),
                Value<int> subtotalCents = const Value.absent(),
                Value<int> taxAmountCents = const Value.absent(),
                Value<int> tipAmountCents = const Value.absent(),
                Value<int> discountAmountCents = const Value.absent(),
                Value<int> totalAmountCents = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountCode = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<String?> lastFourDigits = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String?> authorizationCode = const Value.absent(),
                Value<DateTime> processedAt = const Value.absent(),
                Value<int> processedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion(
                id: id,
                invoiceNumber: invoiceNumber,
                customerName: customerName,
                subtotalCents: subtotalCents,
                taxAmountCents: taxAmountCents,
                tipAmountCents: tipAmountCents,
                discountAmountCents: discountAmountCents,
                totalAmountCents: totalAmountCents,
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
                Value<String?> customerName = const Value.absent(),
                required int subtotalCents,
                required int taxAmountCents,
                required int tipAmountCents,
                required int discountAmountCents,
                required int totalAmountCents,
                required String paymentMethod,
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountCode = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<String?> lastFourDigits = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String?> authorizationCode = const Value.absent(),
                required DateTime processedAt,
                required int processedBy,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => InvoicesCompanion.insert(
                id: id,
                invoiceNumber: invoiceNumber,
                customerName: customerName,
                subtotalCents: subtotalCents,
                taxAmountCents: taxAmountCents,
                tipAmountCents: tipAmountCents,
                discountAmountCents: discountAmountCents,
                totalAmountCents: totalAmountCents,
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                processedBy = false,
                invoiceTicketsRefs = false,
                paymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (invoiceTicketsRefs) db.invoiceTickets,
                    if (paymentsRefs) db.payments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (processedBy) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.processedBy,
                                    referencedTable: $$InvoicesTableReferences
                                        ._processedByTable(db),
                                    referencedColumn: $$InvoicesTableReferences
                                        ._processedByTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (invoiceTicketsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          InvoiceTicket
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._invoiceTicketsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).invoiceTicketsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (paymentsRefs)
                        await $_getPrefetchedData<
                          Invoice,
                          $InvoicesTable,
                          Payment
                        >(
                          currentTable: table,
                          referencedTable: $$InvoicesTableReferences
                              ._paymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InvoicesTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.invoiceId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
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
      (Invoice, $$InvoicesTableReferences),
      Invoice,
      PrefetchHooks Function({
        bool processedBy,
        bool invoiceTicketsRefs,
        bool paymentsRefs,
      })
    >;
typedef $$InvoiceTicketsTableCreateCompanionBuilder =
    InvoiceTicketsCompanion Function({
      required String invoiceId,
      required String ticketId,
      Value<int?> allocatedAmountCents,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$InvoiceTicketsTableUpdateCompanionBuilder =
    InvoiceTicketsCompanion Function({
      Value<String> invoiceId,
      Value<String> ticketId,
      Value<int?> allocatedAmountCents,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

final class $$InvoiceTicketsTableReferences
    extends BaseReferences<_$PosDatabase, $InvoiceTicketsTable, InvoiceTicket> {
  $$InvoiceTicketsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InvoicesTable _invoiceIdTable(_$PosDatabase db) =>
      db.invoices.createAlias(
        $_aliasNameGenerator(db.invoiceTickets.invoiceId, db.invoices.id),
      );

  $$InvoicesTableProcessedTableManager get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id')!;

    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TicketsTable _ticketIdTable(_$PosDatabase db) =>
      db.tickets.createAlias(
        $_aliasNameGenerator(db.invoiceTickets.ticketId, db.tickets.id),
      );

  $$TicketsTableProcessedTableManager get ticketId {
    final $_column = $_itemColumn<String>('ticket_id')!;

    final manager = $$TicketsTableTableManager(
      $_db,
      $_db.tickets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ticketIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InvoiceTicketsTableFilterComposer
    extends Composer<_$PosDatabase, $InvoiceTicketsTable> {
  $$InvoiceTicketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get allocatedAmountCents => $composableBuilder(
    column: $table.allocatedAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TicketsTableFilterComposer get ticketId {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceTicketsTableOrderingComposer
    extends Composer<_$PosDatabase, $InvoiceTicketsTable> {
  $$InvoiceTicketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get allocatedAmountCents => $composableBuilder(
    column: $table.allocatedAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TicketsTableOrderingComposer get ticketId {
    final $$TicketsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableOrderingComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceTicketsTableAnnotationComposer
    extends Composer<_$PosDatabase, $InvoiceTicketsTable> {
  $$InvoiceTicketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get allocatedAmountCents => $composableBuilder(
    column: $table.allocatedAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TicketsTableAnnotationComposer get ticketId {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InvoiceTicketsTableTableManager
    extends
        RootTableManager<
          _$PosDatabase,
          $InvoiceTicketsTable,
          InvoiceTicket,
          $$InvoiceTicketsTableFilterComposer,
          $$InvoiceTicketsTableOrderingComposer,
          $$InvoiceTicketsTableAnnotationComposer,
          $$InvoiceTicketsTableCreateCompanionBuilder,
          $$InvoiceTicketsTableUpdateCompanionBuilder,
          (InvoiceTicket, $$InvoiceTicketsTableReferences),
          InvoiceTicket,
          PrefetchHooks Function({bool invoiceId, bool ticketId})
        > {
  $$InvoiceTicketsTableTableManager(
    _$PosDatabase db,
    $InvoiceTicketsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceTicketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceTicketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceTicketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> invoiceId = const Value.absent(),
                Value<String> ticketId = const Value.absent(),
                Value<int?> allocatedAmountCents = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoiceTicketsCompanion(
                invoiceId: invoiceId,
                ticketId: ticketId,
                allocatedAmountCents: allocatedAmountCents,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String invoiceId,
                required String ticketId,
                Value<int?> allocatedAmountCents = const Value.absent(),
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => InvoiceTicketsCompanion.insert(
                invoiceId: invoiceId,
                ticketId: ticketId,
                allocatedAmountCents: allocatedAmountCents,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InvoiceTicketsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({invoiceId = false, ticketId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (invoiceId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.invoiceId,
                                referencedTable: $$InvoiceTicketsTableReferences
                                    ._invoiceIdTable(db),
                                referencedColumn:
                                    $$InvoiceTicketsTableReferences
                                        ._invoiceIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (ticketId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ticketId,
                                referencedTable: $$InvoiceTicketsTableReferences
                                    ._ticketIdTable(db),
                                referencedColumn:
                                    $$InvoiceTicketsTableReferences
                                        ._ticketIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InvoiceTicketsTableProcessedTableManager =
    ProcessedTableManager<
      _$PosDatabase,
      $InvoiceTicketsTable,
      InvoiceTicket,
      $$InvoiceTicketsTableFilterComposer,
      $$InvoiceTicketsTableOrderingComposer,
      $$InvoiceTicketsTableAnnotationComposer,
      $$InvoiceTicketsTableCreateCompanionBuilder,
      $$InvoiceTicketsTableUpdateCompanionBuilder,
      (InvoiceTicket, $$InvoiceTicketsTableReferences),
      InvoiceTicket,
      PrefetchHooks Function({bool invoiceId, bool ticketId})
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      required String id,
      required String ticketId,
      Value<String?> invoiceId,
      required String paymentMethod,
      required int amountCents,
      Value<int?> tipAmountCents,
      Value<int?> taxAmountCents,
      Value<int?> discountAmountCents,
      Value<int?> totalAmountCents,
      Value<String?> discountType,
      Value<String?> discountCode,
      Value<String?> discountReason,
      Value<String?> cardType,
      Value<String?> lastFourDigits,
      Value<String?> transactionId,
      Value<String?> authorizationCode,
      Value<DateTime?> processedAt,
      Value<int?> processedBy,
      Value<int?> authorizedBy,
      Value<String?> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<String> id,
      Value<String> ticketId,
      Value<String?> invoiceId,
      Value<String> paymentMethod,
      Value<int> amountCents,
      Value<int?> tipAmountCents,
      Value<int?> taxAmountCents,
      Value<int?> discountAmountCents,
      Value<int?> totalAmountCents,
      Value<String?> discountType,
      Value<String?> discountCode,
      Value<String?> discountReason,
      Value<String?> cardType,
      Value<String?> lastFourDigits,
      Value<String?> transactionId,
      Value<String?> authorizationCode,
      Value<DateTime?> processedAt,
      Value<int?> processedBy,
      Value<int?> authorizedBy,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PaymentsTableReferences
    extends BaseReferences<_$PosDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TicketsTable _ticketIdTable(_$PosDatabase db) => db.tickets
      .createAlias($_aliasNameGenerator(db.payments.ticketId, db.tickets.id));

  $$TicketsTableProcessedTableManager get ticketId {
    final $_column = $_itemColumn<String>('ticket_id')!;

    final manager = $$TicketsTableTableManager(
      $_db,
      $_db.tickets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ticketIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InvoicesTable _invoiceIdTable(_$PosDatabase db) => db.invoices
      .createAlias($_aliasNameGenerator(db.payments.invoiceId, db.invoices.id));

  $$InvoicesTableProcessedTableManager? get invoiceId {
    final $_column = $_itemColumn<String>('invoice_id');
    if ($_column == null) return null;
    final manager = $$InvoicesTableTableManager(
      $_db,
      $_db.invoices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_invoiceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _processedByTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.payments.processedBy, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager? get processedBy {
    final $_column = $_itemColumn<int>('processed_by');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_processedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _authorizedByTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.payments.authorizedBy, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager? get authorizedBy {
    final $_column = $_itemColumn<int>('authorized_by');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_authorizedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tipAmountCents => $composableBuilder(
    column: $table.tipAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get taxAmountCents => $composableBuilder(
    column: $table.taxAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountAmountCents => $composableBuilder(
    column: $table.discountAmountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
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

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TicketsTableFilterComposer get ticketId {
    final $$TicketsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableFilterComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableFilterComposer get invoiceId {
    final $$InvoicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableFilterComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get processedBy {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.processedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get authorizedBy {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorizedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tipAmountCents => $composableBuilder(
    column: $table.tipAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get taxAmountCents => $composableBuilder(
    column: $table.taxAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountAmountCents => $composableBuilder(
    column: $table.discountAmountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
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

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TicketsTableOrderingComposer get ticketId {
    final $$TicketsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableOrderingComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableOrderingComposer get invoiceId {
    final $$InvoicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableOrderingComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get processedBy {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.processedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get authorizedBy {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorizedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tipAmountCents => $composableBuilder(
    column: $table.tipAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get taxAmountCents => $composableBuilder(
    column: $table.taxAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountAmountCents => $composableBuilder(
    column: $table.discountAmountCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAmountCents => $composableBuilder(
    column: $table.totalAmountCents,
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

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TicketsTableAnnotationComposer get ticketId {
    final $$TicketsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.tickets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TicketsTableAnnotationComposer(
            $db: $db,
            $table: $db.tickets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InvoicesTableAnnotationComposer get invoiceId {
    final $$InvoicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.invoiceId,
      referencedTable: $db.invoices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InvoicesTableAnnotationComposer(
            $db: $db,
            $table: $db.invoices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get processedBy {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.processedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get authorizedBy {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.authorizedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (Payment, $$PaymentsTableReferences),
          Payment,
          PrefetchHooks Function({
            bool ticketId,
            bool invoiceId,
            bool processedBy,
            bool authorizedBy,
          })
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
                Value<int> amountCents = const Value.absent(),
                Value<int?> tipAmountCents = const Value.absent(),
                Value<int?> taxAmountCents = const Value.absent(),
                Value<int?> discountAmountCents = const Value.absent(),
                Value<int?> totalAmountCents = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountCode = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<String?> lastFourDigits = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String?> authorizationCode = const Value.absent(),
                Value<DateTime?> processedAt = const Value.absent(),
                Value<int?> processedBy = const Value.absent(),
                Value<int?> authorizedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                ticketId: ticketId,
                invoiceId: invoiceId,
                paymentMethod: paymentMethod,
                amountCents: amountCents,
                tipAmountCents: tipAmountCents,
                taxAmountCents: taxAmountCents,
                discountAmountCents: discountAmountCents,
                totalAmountCents: totalAmountCents,
                discountType: discountType,
                discountCode: discountCode,
                discountReason: discountReason,
                cardType: cardType,
                lastFourDigits: lastFourDigits,
                transactionId: transactionId,
                authorizationCode: authorizationCode,
                processedAt: processedAt,
                processedBy: processedBy,
                authorizedBy: authorizedBy,
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
                required int amountCents,
                Value<int?> tipAmountCents = const Value.absent(),
                Value<int?> taxAmountCents = const Value.absent(),
                Value<int?> discountAmountCents = const Value.absent(),
                Value<int?> totalAmountCents = const Value.absent(),
                Value<String?> discountType = const Value.absent(),
                Value<String?> discountCode = const Value.absent(),
                Value<String?> discountReason = const Value.absent(),
                Value<String?> cardType = const Value.absent(),
                Value<String?> lastFourDigits = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<String?> authorizationCode = const Value.absent(),
                Value<DateTime?> processedAt = const Value.absent(),
                Value<int?> processedBy = const Value.absent(),
                Value<int?> authorizedBy = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                ticketId: ticketId,
                invoiceId: invoiceId,
                paymentMethod: paymentMethod,
                amountCents: amountCents,
                tipAmountCents: tipAmountCents,
                taxAmountCents: taxAmountCents,
                discountAmountCents: discountAmountCents,
                totalAmountCents: totalAmountCents,
                discountType: discountType,
                discountCode: discountCode,
                discountReason: discountReason,
                cardType: cardType,
                lastFourDigits: lastFourDigits,
                transactionId: transactionId,
                authorizationCode: authorizationCode,
                processedAt: processedAt,
                processedBy: processedBy,
                authorizedBy: authorizedBy,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ticketId = false,
                invoiceId = false,
                processedBy = false,
                authorizedBy = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ticketId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ticketId,
                                    referencedTable: $$PaymentsTableReferences
                                        ._ticketIdTable(db),
                                    referencedColumn: $$PaymentsTableReferences
                                        ._ticketIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (invoiceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.invoiceId,
                                    referencedTable: $$PaymentsTableReferences
                                        ._invoiceIdTable(db),
                                    referencedColumn: $$PaymentsTableReferences
                                        ._invoiceIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (processedBy) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.processedBy,
                                    referencedTable: $$PaymentsTableReferences
                                        ._processedByTable(db),
                                    referencedColumn: $$PaymentsTableReferences
                                        ._processedByTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (authorizedBy) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.authorizedBy,
                                    referencedTable: $$PaymentsTableReferences
                                        ._authorizedByTable(db),
                                    referencedColumn: $$PaymentsTableReferences
                                        ._authorizedByTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
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
      (Payment, $$PaymentsTableReferences),
      Payment,
      PrefetchHooks Function({
        bool ticketId,
        bool invoiceId,
        bool processedBy,
        bool authorizedBy,
      })
    >;
typedef $$TechnicianSchedulesTableCreateCompanionBuilder =
    TechnicianSchedulesCompanion Function({
      required String id,
      required int employeeId,
      required String dayOfWeek,
      Value<bool> isScheduledOff,
      Value<int?> startTime,
      Value<int?> endTime,
      Value<DateTime?> effectiveDate,
      Value<String?> notes,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TechnicianSchedulesTableUpdateCompanionBuilder =
    TechnicianSchedulesCompanion Function({
      Value<String> id,
      Value<int> employeeId,
      Value<String> dayOfWeek,
      Value<bool> isScheduledOff,
      Value<int?> startTime,
      Value<int?> endTime,
      Value<DateTime?> effectiveDate,
      Value<String?> notes,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TechnicianSchedulesTableReferences
    extends
        BaseReferences<
          _$PosDatabase,
          $TechnicianSchedulesTable,
          TechnicianSchedule
        > {
  $$TechnicianSchedulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EmployeesTable _employeeIdTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(
          db.technicianSchedules.employeeId,
          db.employees.id,
        ),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  ColumnFilters<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isScheduledOff => $composableBuilder(
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

  ColumnFilters<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  ColumnOrderings<String> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isScheduledOff => $composableBuilder(
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

  ColumnOrderings<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<String> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<bool> get isScheduledOff => $composableBuilder(
    column: $table.isScheduledOff,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<int> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (TechnicianSchedule, $$TechnicianSchedulesTableReferences),
          TechnicianSchedule,
          PrefetchHooks Function({bool employeeId})
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
                Value<bool> isScheduledOff = const Value.absent(),
                Value<int?> startTime = const Value.absent(),
                Value<int?> endTime = const Value.absent(),
                Value<DateTime?> effectiveDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
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
                Value<bool> isScheduledOff = const Value.absent(),
                Value<int?> startTime = const Value.absent(),
                Value<int?> endTime = const Value.absent(),
                Value<DateTime?> effectiveDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$TechnicianSchedulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable:
                                    $$TechnicianSchedulesTableReferences
                                        ._employeeIdTable(db),
                                referencedColumn:
                                    $$TechnicianSchedulesTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (TechnicianSchedule, $$TechnicianSchedulesTableReferences),
      TechnicianSchedule,
      PrefetchHooks Function({bool employeeId})
    >;
typedef $$TimeEntriesTableCreateCompanionBuilder =
    TimeEntriesCompanion Function({
      required String id,
      required int employeeId,
      required DateTime clockIn,
      Value<DateTime?> clockOut,
      Value<int> breakMinutes,
      Value<double?> totalHours,
      Value<String> status,
      Value<int?> editedBy,
      Value<String?> editReason,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TimeEntriesTableUpdateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<String> id,
      Value<int> employeeId,
      Value<DateTime> clockIn,
      Value<DateTime?> clockOut,
      Value<int> breakMinutes,
      Value<double?> totalHours,
      Value<String> status,
      Value<int?> editedBy,
      Value<String?> editReason,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TimeEntriesTableReferences
    extends BaseReferences<_$PosDatabase, $TimeEntriesTable, TimeEntry> {
  $$TimeEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.timeEntries.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<int>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _editedByTable(_$PosDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.timeEntries.editedBy, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager? get editedBy {
    final $_column = $_itemColumn<int>('edited_by');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_editedByTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  ColumnFilters<DateTime> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clockOut => $composableBuilder(
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

  ColumnFilters<String> get editReason => $composableBuilder(
    column: $table.editReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get editedBy {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  ColumnOrderings<DateTime> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clockOut => $composableBuilder(
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

  ColumnOrderings<String> get editReason => $composableBuilder(
    column: $table.editReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get editedBy {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumn<DateTime> get clockIn =>
      $composableBuilder(column: $table.clockIn, builder: (column) => column);

  GeneratedColumn<DateTime> get clockOut =>
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

  GeneratedColumn<String> get editReason => $composableBuilder(
    column: $table.editReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get editedBy {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.editedBy,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (TimeEntry, $$TimeEntriesTableReferences),
          TimeEntry,
          PrefetchHooks Function({bool employeeId, bool editedBy})
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
                Value<DateTime> clockIn = const Value.absent(),
                Value<DateTime?> clockOut = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<double?> totalHours = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> editedBy = const Value.absent(),
                Value<String?> editReason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
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
                required DateTime clockIn,
                Value<DateTime?> clockOut = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<double?> totalHours = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> editedBy = const Value.absent(),
                Value<String?> editReason = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
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
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false, editedBy = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$TimeEntriesTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$TimeEntriesTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (editedBy) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.editedBy,
                                referencedTable: $$TimeEntriesTableReferences
                                    ._editedByTable(db),
                                referencedColumn: $$TimeEntriesTableReferences
                                    ._editedByTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (TimeEntry, $$TimeEntriesTableReferences),
      TimeEntry,
      PrefetchHooks Function({bool employeeId, bool editedBy})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<String?> category,
      Value<String?> dataType,
      Value<String?> description,
      Value<bool> isSystem,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<String?> category,
      Value<String?> dataType,
      Value<String?> description,
      Value<bool> isSystem,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
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

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
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

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
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

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
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
                Value<bool> isSystem = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
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
                Value<bool> isSystem = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
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

class $PosDatabaseManager {
  final _$PosDatabase _db;
  $PosDatabaseManager(this._db);
  $$ServiceCategoriesTableTableManager get serviceCategories =>
      $$ServiceCategoriesTableTableManager(_db, _db.serviceCategories);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$ServicesTableTableManager get services =>
      $$ServicesTableTableManager(_db, _db.services);
  $$EmployeeServiceCategoriesTableTableManager get employeeServiceCategories =>
      $$EmployeeServiceCategoriesTableTableManager(
        _db,
        _db.employeeServiceCategories,
      );
  $$AppointmentsTableTableManager get appointments =>
      $$AppointmentsTableTableManager(_db, _db.appointments);
  $$TicketsTableTableManager get tickets =>
      $$TicketsTableTableManager(_db, _db.tickets);
  $$TicketServicesTableTableManager get ticketServices =>
      $$TicketServicesTableTableManager(_db, _db.ticketServices);
  $$AppointmentServicesTableTableManager get appointmentServices =>
      $$AppointmentServicesTableTableManager(_db, _db.appointmentServices);
  $$InvoicesTableTableManager get invoices =>
      $$InvoicesTableTableManager(_db, _db.invoices);
  $$InvoiceTicketsTableTableManager get invoiceTickets =>
      $$InvoiceTicketsTableTableManager(_db, _db.invoiceTickets);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$TechnicianSchedulesTableTableManager get technicianSchedules =>
      $$TechnicianSchedulesTableTableManager(_db, _db.technicianSchedules);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db, _db.timeEntries);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}

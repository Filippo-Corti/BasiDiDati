<?php

function notifyError($msg)
{
    echo "<br><b>ERRORE: {$msg}</b><br>";
    exit();
}

function getStandardInputFields($connection, &$columns, $disabledFields = NULL, $valuesForFields = NULL)
{
    $formFields = array();
    foreach ($columns as $col) {
		$toedit = ($disabledFields) ? !in_array($col['column_name'], $disabledFields) : true;
		$value = ($valuesForFields && array_key_exists($col['column_name'], $valuesForFields)) ? $valuesForFields[$col['column_name']] : NULL;
        $formFields[$col['ordinal_position']] = getStandardInputField($connection, $col, $toedit, $value);
    }
    return $formFields;
}

function getReferentialInputFields($connection, &$columns, $foreignKeys, $disabledFields = NULL, $valuesForFields = NULL)
{
    $formFields = array();
    $referencedTables = array();
    foreach ($foreignKeys as $fk) {
        if ($fk['ordinal_position'] == 1) {
            $referencedTables[] = array('constraint' => $fk['constraint_name'], 'referredtable' => $fk['referredtable'], 'column_name' => $fk['column_name']);
        }
    }
    foreach ($referencedTables as $referencedTable) {
		$toedit = ($disabledFields) ? !in_array($referencedTable['column_name'], $disabledFields) : true;
		$value = ($valuesForFields && array_key_exists($referencedTable['column_name'], $valuesForFields)) ? $valuesForFields[$referencedTable['column_name']] : NULL;
        $formField = getReferentialInputField($connection, $columns, $foreignKeys, $referencedTable, $index, $toedit, $valuesForFields);
        $formFields[$index] = $formField;
    }
    return $formFields;
}

function getStandardInputField($connection, $column_data, $editable = true, $value = NULL)
{
    $name = ucfirst($column_data['column_name']);
    $field_type = $column_data['udt_name'];
    switch ($field_type) {
        case 'bpchar':
            return buildInputText($name, $column_data['character_maximum_length'], $column_data['character_maximum_length'], $column_data['is_nullable'] == 'NO', $editable, $value);
        case 'varchar':
            return buildInputText($name, 0, $column_data['character_maximum_length'], $column_data['is_nullable'] == 'NO', $editable, $value);
        case 'numeric':
            return buildInputNumber($name, $column_data['numeric_precision'], $column_data['numeric_scale'], $column_data['is_nullable'] == 'NO', $editable, $value);
        case 'date':
            return buildInputDate($name, $column_data['is_nullable'] == 'NO', $editable, $value);
        case 'time':
            return buildInputTime($name, $column_data['is_nullable'] == 'NO', $editable, $value);
        case 'timestamp':
            return buildInputDateTime($name, $column_data['is_nullable'] == 'NO', $editable, $value);
        default:
            //User-defined Enum
            $query = "SELECT enum_range(NULL::{$field_type})";
            try {
                $result = executeQuery($connection, $query);
            } catch (Exception $e) {
                notifyError($e->getMessage());
            }
            $enumValues = substr(pg_fetch_array($result)['enum_range'], 1, -1); //Trim { and }
            return buildInputSelect($name, explode(',', $enumValues), $column_data['is_nullable'] == 'NO', $editable, $value);
    }
}

function getReferentialInputField($connection, &$columns, $foreignKeys, $referencedTable, &$index, $toedit = true, $valuesForFields = NULL)
{
    //Find Referenced and Referring Columns
    $referencedData = array();
    $constraintName = $referencedTable['constraint'];
    $referencedTable = $referencedTable['referredtable'];
    foreach ($foreignKeys as $fk) {
        if ($fk['referredtable'] == $referencedTable && $constraintName = $fk['constraint_name']) {
            $referencedData[] = $fk;
        }
    }
    $referencedColumns = array_map(fn($el) => $el['referredcolumn'], $referencedData);
    $referencedColumnsString = implode(", ", $referencedColumns);
    $referringColumns = array_map(fn($el) => ucfirst($el['column_name']), $referencedData);
    $referringColumnsString = implode(", ", $referringColumns);

    //Execute Query to get Selection Data 
    $query = "SELECT {$referencedColumnsString} FROM {$referencedTable}";
    try {
        $dataForSelectInput = executeQuery($connection, $query);
    } catch (Exception $e) {
        notifyError($e->getMessage());
    }
    $dataForSelectInput = array_map(fn($el) => implode(', ', $el), pg_fetch_all($dataForSelectInput));

    //Find Correct Index in the Page 
    $positionInPage = array_filter($columns, fn($el) => in_array(ucfirst($el['column_name']), $referringColumns));
    $index = max(array_map(fn($el) => $el['ordinal_position'], $positionInPage));
    $isRequired = in_array("NO", array_map(fn($el) => ucfirst($el['is_nullable']), array_filter($columns, fn($el) => in_array(ucfirst($el['column_name']), $referringColumns))));

    //Remove Referred Columns so that they don't get evaluated again
    $columns = array_filter($columns, fn($el) => !in_array(ucfirst($el['column_name']), $referringColumns));
    
	$values = array_map(function($el) use ($valuesForFields) { 
		return ($valuesForFields && array_key_exists(strtolower($el), $valuesForFields)) ? $valuesForFields[strtolower($el)] : NULL;
	}, $referringColumns);
	$value = implode(', ', $values); 
	
    if ($toedit) {
        return buildInputSelect($referringColumnsString, $dataForSelectInput, $isRequired, true, $value);
    }
    return buildInputSelect($referringColumnsString, $dataForSelectInput, $isRequired);
}
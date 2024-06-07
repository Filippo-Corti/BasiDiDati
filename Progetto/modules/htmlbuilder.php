<?php

function buildTable($results, $columns, $table)
{
    //Intestation
    $str = '<table class="w-100">';
    $str .= '<tr>';
    foreach ($columns as $col) {
        $col = ucfirst($col);
        $str .= "<th> {$col} </th>";
    }
    $str .= "<th> Actions </th>";
    $str .= '</tr>';
    foreach ($results as $row) {
        $str .= '<tr><form method="POST" action="opmanager.php">';
        foreach ($columns as $col) {
            $str .= "<td> <input type='hidden' name='{$col}' value='{$row[$col]}'> {$row[$col]} </td>";
        }
        $str .= "<td><input type='submit' name='operation' value='Edit' class='btn btn-edit'>
				<input type='submit' name='operation' value='Delete' class='btn btn-delete'></td>";
        $str .= '</form></tr>';
    }
    return $str . '</table>';
}

function buildToast($id, $type, $title, $content)
{

    

    switch ($type) {
        case NotificationType::Success:
            $bgClass = 'success';
            $icon = 'check.svg';
            break;
        case NotificationType::Error:
            $bgClass = 'danger';
            $icon = 'exclamation.svg';
            break;
        default:
            return;
    }

    return <<<EOD
    <div id="{$id}" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bs-config='{"delay":5000}'>
                <div class="toast-header">
                    <div class="rounded me-2 d-flex justify-content-center p-1 bg-{$bgClass}">
                        <img src="img/{$icon}">
                    </div>
                    <strong class="me-auto">{$title}</strong>
                    <small>Just Now</small>
                    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
                <div class="toast-body">
                    {$content}
                </div>
            </div>
    EOD;
}

function buildInputText($name, $minsize, $maxsize, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" type="text" name="{$name}" id="{$name}" minlength="{$minsize}" maxlength="{$maxsize}" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputNumber($name, $totalDigits, $decimalDigits, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);
    $maxNumber = pow(10, $totalDigits - $decimalDigits) - 1;
    $decimalPrecision = 1 / pow(10, $decimalDigits);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="number" max="{$maxNumber}" step="{$decimalPrecision}" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputBoolean($name)
{
    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="checkbox">
        <br>
    EOD;
}

function buildInputDate($name, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="date" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputTime($name, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="time" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputDateTime($name, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = getEditable($editable);
    $valueStr = getValue($value);

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        <input class="form-control rounded-pill" name="{$name}" type="datetime-local" {$valueStr} {$getRequired} {$getEditable}>
        <br>
    EOD;
}

function buildInputSelect($name, $options, $required, $editable = true, $value = NULL)
{
    $getRequired = getRequired($required);
    $getEditable = "";
    $getAlternativeInput = "";
    if (!$editable) {
        $getEditable = "disabled";
        $getAlternativeInput = "<input type='hidden' name='{$name}' value='{$value}'>";
    }

    $optionsStr = "";
    $selected = false;
    foreach ($options as $option) {
        if ($option == $value) {
            $optionsStr .= "<option value='{$option}' selected>{$option}</option>";
            $selected = true;
        } else {
            $optionsStr .= "<option value='{$option}'>{$option}</option>";
        }
    }

    if (!$selected) {
        $optionsStr = '<option value="" selected>--</option>' . $optionsStr;
    } else {
        $optionsStr = '<option value="">--</option>' . $optionsStr;
    }

    return <<<EOD
        <label class="form-label" for="{$name}">{$name}:</label>
        {$getAlternativeInput}
        <select class="form-select rounded-pill" name="{$name}" id="{$name}" {$getRequired} {$getEditable}>
        {$optionsStr}
        </select>
        <br>
    EOD;
}

function getRequired($r)
{
    return ($r) ? "required" : "";
}

function getEditable($e)
{
    return ($e) ? "" : "readonly";
}

function getValue($v)
{
    return ($v) ? "value='{$v}'" : "";
}

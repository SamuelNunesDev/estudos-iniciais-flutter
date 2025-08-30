<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class ArquivoController extends Controller
{

    public function store(Request $request)
    {
        $arquivo = $request->file('arquivo');
        Log::alert('Arquivo inválido ou muito grande', [
        'error' => $arquivo ? $arquivo->getError() : null,
        'size' => $arquivo ? $arquivo->getSize() : null,
    ]);
        return new JsonResponse([
            'arquivo' => $request->file('arquivo')->store()
        ], JsonResponse::HTTP_CREATED);
    }
}
